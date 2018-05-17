import logging
import random
import time
from pydoc import locate


import config
import ops

import sql
import assets 
import os, sys

from core import log

from core.modes import Mode
from core.modestate import StatefulMode, ModeStateChangeHandler, DefaultModeHandler

from core.states import State
from core.serv import ServiceHost
from core import var

from alchemy import SQLServiceProfile
from alchemy_modestate import AlchemyModeStateReader, AlchemyModeStateWriter
from core import introspection

from ops import ops_func
from db.generated.sqla_service import t_v_mode_default_dispatch 

LOG = log.get_safe_log(__name__, logging.DEBUG)


class ServiceProcess(ServiceHost):
    def __init__(self, vector, owner=None, stop_on_errors=True, before=None, after=None):
        self.handlers = {'.'.join([__name__, self.__class__.__name__]): self}
        self.modes = {}
        self.state_change_handler = ModeStateChangeHandler()
        self.mode_state_reader = AlchemyModeStateReader()
        self.mode_state_writer = AlchemyModeStateWriter()
        profile = SQLServiceProfile.retrieve(var.profile)
        # super().__init__() must be called before accessing selector instance
        super(ServiceProcess, self).__init__(profile, vector, owner, stop_on_errors, before, after)

    def _register_handler(self, qname):
        if qname not in self.handlers:
            clazz = locate(qname)
            if clazz is None:
                LOG.warning("%s not found." % qname)
                return

            # self.handlers[qname] = clazz(self, self.vector)
            self.handlers[qname] = clazz(self, qname, self.selector, self.vector)

    def _build_instance_registry(self):
        for rule in self.profile.switch_rules:
            qname = introspection.get_qualified_name(rule.condition_dispatch.package_name, rule.condition_dispatch.module_name, \
                rule.condition_dispatch.class_name)
            if qname: 
                self._register_handler(qname)

            qname = introspection.get_qualified_name(rule.before_dispatch.package_name, rule.before_dispatch.module_name, \
                rule.before_dispatch.class_name)
            if qname: 
                self._register_handler(qname)

            qname = introspection.get_qualified_name(rule.after_dispatch.package_name, rule.after_dispatch.module_name, \
                rule.after_dispatch.class_name)
            if qname: 
                self._register_handler(qname)

        self.moderecords = sql.retrieve_values2('v_mode_default_dispatch_w_id', ['mode_id', 'mode_name', 'stateful_flag', 'handler_package', 'handler_module', 'handler_class', 'handler_func', \
            'priority', 'dec_priority_amount', 'inc_priority_amount', 'times_to_complete', 'error_tolerance'], [], schema=config.db_service)

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
                        [str(result.id)], schema=config.db_service) 
                        
                    for rec in staterecs:
                        state = result.get_state(rec.state_name)
                        state.action = self._create_func(rec.package_name, rec.module_name, rec.class_name, rec.func_name)
                        if state.is_initial_state:
                            result.set_state(state)

                    transrecs = sql.retrieve_values2('v_mode_state_default_transition_rule_dispatch_w_id', ['name', 'mode_id', 'begin_state', 'end_state', \
                        'condition_package', 'condition_module', 'condition_class', 'condition_func'], [], schema=config.db_service) 

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
        for rule in self.profile.switch_rules:
            begin = self.modes[rule.begin_mode.name] if rule.begin_mode.name in self.modes else None
            end = self.modes[rule.end_mode.name] if rule.end_mode.name in self.modes else None

            condition = self._create_func(rule.condition_dispatch.package_name, rule.condition_dispatch.module_name, \
                rule.condition_dispatch.class_name, rule.condition_dispatch.func_name)

            before = self._create_func(rule.before_dispatch.package_name, rule.before_dispatch.module_name, \
                rule.before_dispatch.class_name, rule.before_dispatch.func_name)

            after = self._create_func(rule.after_dispatch.package_name, rule.after_dispatch.module_name, \
                rule.after_dispatch.class_name, rule.after_dispatch.func_name)

            name = "%s ::: %s" % (rule.name, end.name) if begin else 'start' 

            self.selector.add_rule(name, begin, end, condition, before, after)


    def setup(self):
        self.selector.remove_at_error_tolerance = True
        self.process_handler = self.create_service_handler()
        # self.handlers['.'.join([__name__, self.process_handler.__class__.__name__])] = self.process_handler
        self._build_instance_registry()
        for record in self.moderecords:
            self.__dict__[record.mode_name] = self.create_mode(record.mode_name)

        self._create_switch_rules()


    def create_service_handler(self):

        package_name = self.profile.service_handler_dispatch.package_name
        module_name =  self.profile.service_handler_dispatch.module_name
        class_name = self.profile.service_handler_dispatch.class_name

        module = __import__(module_name)
        qname = introspection.get_qualified_name(package_name, module_name, class_name)

        self._register_handler(qname)

    # def after_switch(self, selector, mode):
    #     print "after switch %s" % mode.name
    #     self.process_handler.after_switch(selector, mode)
        
    # def before_switch(self, selector, mode):
    #     print "before switch %s" % mode.name
    #     self.process_handler.before_switch(selector, mode)


