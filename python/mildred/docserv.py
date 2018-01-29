import logging
import random
import time
from pydoc import locate


import config
import ops

import sql
import assets 
import os

from core import log
from const import SCAN, MATCH, CLEAN, ANALYZE, FIX, SYNC, STARTUP, SHUTDOWN, REPORT, REQUESTS, INITIAL, SCANNER, SCAN_DISCOVER, SCAN_UPDATE, SCAN_MONITOR, HSCAN, DEEP, USCAN

from core.modes import Mode
from core.modestate import StatefulMode, ModeStateChangeHandler, DefaultModeHandler

from core.states import State
from core.serv import SingleSelectorServiceProcess

from alchemy_modestate import AlchemyModeStateReader, AlchemyModeStateWriter
from core import introspection

from ops import ops_func

LOG = log.get_safe_log(__name__, logging.DEBUG)


class DocumentServiceProcess(SingleSelectorServiceProcess):
    def __init__(self, name, vector, owner=None, stop_on_errors=True, before=None, after=None):
        self.handlers = {'.'.join([__name__, self.__class__.__name__]): self}
        self.modes = {}
        self.state_change_handler = ModeStateChangeHandler()
        self.mode_state_reader = AlchemyModeStateReader()
        self.mode_state_writer = AlchemyModeStateWriter()

        # super().__init__() must be called before accessing selector instance
        super(DocumentServiceProcess, self).__init__(name, vector, owner=owner, stop_on_errors=stop_on_errors, before=before, after=after)

    # selector callbacks
    
    def after_switch(self, selector, mode):
        self.process_handler.after_switch(selector, mode)

    def before_switch(self, selector, mode):
        self.process_handler.before_switch(selector, mode)

    def _register_handler(self, qname):
        if qname not in self.handlers:
            clazz = locate(qname)
            if clazz is None:
                print("%s not found." % qname)
                return

            self.handlers[qname] = clazz(self, self.vector)


    def _build_instance_registry(self):

        # test = introspection.get_qualified_name(__package__, __module__, self.__class__.__name__)
        self.switchrules = sql.retrieve_values2('v_mode_switch_rule_dispatch_w_id', ['name', 'begin_mode_id', 'begin_mode', 'end_mode_id', 'end_mode', \
            'condition_package', 'condition_module', 'condition_class', 'condition_func', \
            'before_package', 'before_module', 'before_class', 'before_func', \
            'after_package', 'after_module', 'after_class', 'after_func'], [], schema='mildred_introspection')

        for rule in self.switchrules:
            qname = introspection.get_qualified_name(rule.condition_package, rule.condition_module, rule.condition_class)
            if qname: 
                self._register_handler(qname)

            qname = introspection.get_qualified_name(rule.before_package, rule.before_module, rule.before_class)
            if qname: 
                self._register_handler(qname)

            qname = introspection.get_qualified_name(rule.after_package, rule.after_module, rule.after_class)
            if qname: 
                self._register_handler(qname)

        self.moderecords = sql.retrieve_values2('v_mode_default_dispatch_w_id', ['mode_id', 'mode_name', 'stateful_flag', 'handler_package', 'handler_module', 'handler_class', 'handler_func', \
            'priority', 'dec_priority_amount', 'inc_priority_amount', 'times_to_complete', 'error_tolerance'], [], schema='mildred_introspection')

        for record in self.moderecords:
            qname = introspection.get_qualified_name(record.handler_package, record.handler_module, record.handler_class)
            if qname: 
                self._register_handler(qname)

    def _create_func(self, package, module, clazz, func):
        qname = introspection.get_qualified_name(package, module, clazz)
        if qname and qname in self.handlers:
            handler = self.handlers[qname]
            return getattr(handler, func, None)


    def create_mode(self, mode_name):
        result = None
        effect = None

        for moderec in self.moderecords:
            if moderec.mode_name == mode_name:
                effect = self._create_func(moderec.handler_package, moderec.handler_module, moderec.handler_class, moderec.handler_func)

                if moderec.stateful_flag == 1:
                    result = StatefulMode(moderec.mode_name, id=moderec.mode_id, effect=effect, priority=moderec.priority, dec_priority_amount=moderec.dec_priority_amount, \
                        inc_priority_amount=moderec.inc_priority_amount, error_tolerance=moderec.error_tolerance, reader=self.mode_state_reader, writer=self.mode_state_writer, \
                        state_change_handler=self.state_change_handler)

                    staterecs = sql.retrieve_values2('v_mode_state_default_dispatch_w_id', ['mode_id', 'state_id', 'state_name', 'package_name', 'module_name', 'class_name', 'func_name'], \
                        [str(result.id)], schema='mildred_introspection') 
                        
                    for rec in staterecs:
                        state = result.get_state(rec.state_name)
                        state.action = self._create_func(rec.package_name, rec.module_name, rec.class_name, rec.func_name)
                        if state.is_initial_state:
                            result.set_state(state)

                    transrecs = sql.retrieve_values2('v_mode_state_default_transition_rule_dispatch_w_id', ['name', 'mode_id', 'begin_state', 'end_state', \
                        'condition_package', 'condition_module', 'condition_class', 'condition_func'], [], schema='mildred_introspection') 

                    for transition in transrecs:
                        if result.id  == transition.mode_id:
                            condition = self._create_func(transition.condition_package, transition.condition_module, transition.condition_class, transition.condition_func)                            
                            self.state_change_handler.add_transition(result.get_state(transition.begin_state), result.get_state(transition.end_state), condition)
                    
                    self.mode_state_reader.restore(result, self.vector)

                else:
                    result = Mode(moderec.mode_name, id=moderec.mode_id, effect=effect, priority=moderec.priority, dec_priority_amount=moderec.dec_priority_amount, \
                        inc_priority_amount=moderec.inc_priority_amount, error_tolerance=moderec.error_tolerance)
                
                self.modes[mode_name] = result
                break

        return result


    def _create_switch_rules(self):        
        for rule in self.switchrules:
            begin = self.modes[rule.begin_mode] if rule.begin_mode in self.modes else None
            end = self.modes[rule.end_mode] if rule.end_mode in self.modes else None
            
            condition = self._create_func(rule.condition_package, rule.condition_module, rule.condition_class, rule.condition_func)
            before = self._create_func(rule.before_package, rule.before_module, rule.before_class, rule.before_func)
            after = self._create_func(rule.after_package, rule.after_module, rule.after_class, rule.after_func)

            name = "%s ::: %s" % (rule.name, end.name) if begin else 'start' 

            self.selector.add_rule(name, begin, end, condition, before, after)


    # process logic

    def setup(self):
        self.selector.remove_at_error_tolerance = True

        self.process_handler = DocumentServiceProcessHandler(self, '_process_handler_', self.selector, self.vector)
        self.handlers['.'.join([__name__, self.process_handler.__class__.__name__])] = self.process_handler

        print "setting up..."

        self._build_instance_registry()

        for record in self.moderecords:
            self.__dict__[record.mode_name] = self.create_mode(record.mode_name)


        self._create_switch_rules()

        print "setup complete"


def create_service_process(identifier, vector, owner=None, before=None, after=None, alternative=None):
    if alternative is None:
        return DocumentServiceProcess(identifier, vector, owner=owner, before=before, after=after)

    return alternative(identifier, vector)

class ServiceModeInitializer(object):
    pass

class DecisionHandler(object):

    def definitely(self, selector=None, active=None, possible=None): 
        return True

    def maybe(self, selector, active, possible):
        result = bool(random.getrandbits(1))
        return result

    def possibly(self, selector, active, possible):
        count = 0
        for mode in selector.modes:
            if bool(random.getrandbits(1)): 
                count += 1
        return count > 3


class DocumentServiceProcessHandler(DecisionHandler):
    def __init__(self, owner, name, selector, vector):
        super(DocumentServiceProcessHandler, self).__init__()
        self.vector = vector
        self.owner = owner
        self.name = name
        self.selector = selector

        random.seed()

    # selector callbacks

    def after_switch(self, selector, mode):
        pass

    def before_switch(self, selector, mode):
        pass

    # generic rule callbacks

    @ops_func
    def after(self):
        mode = self.selector.active
        LOG.debug("%s after '%s'" % (self.name, mode.name))
    

    @ops_func
    def before(self):
        mode = self.selector.next
        LOG.debug("%s before '%s'" % (self.name, mode.name))
        if mode.active_rule is not None:
            LOG.debug("%s: %s follows '%s', because of '%s'" % \
                (self.name, mode.active_rule.end.name, mode.active_rule.start.name, mode.active_rule.name if mode.active_rule is not None else '...'))

    #TODO: move this mode-specific stuff into docservmodes in preparation for docservmodes to be parametarized
    @ops_func
    def mode_is_available(self, selector, active, possible):
        initial_and_update_scan_complete = self.owner.scan.in_state(self.owner.scan.get_state(SCAN_MONITOR))

        if initial_and_update_scan_complete:
            if possible is self.owner.match:
                if self.vector.has_next(MATCH):
                    return config.match
                    

        return initial_and_update_scan_complete or config.scan == False
