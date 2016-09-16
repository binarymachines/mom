import os, sys, random

from serv import ServerProcess

from modes import Mode, Selector, Rule, Machine 
from direct import Directive

import config, direct, library, calc, scan, report

class MediaServerProcess(ServerProcess):
    def __init__(self, name, directive):
        self.directive = directive
        
        # modes for this process
        self.startmode = Mode("startup", 0, self.started, self.before_start, self.after_start)
        self.evalmode = Mode("eval", 6)
        self.scanmode = Mode("scan", 7)
        self.matchmode = Mode("match", 5)
        self.fixmode = Mode("fix", -5)
        self.reportmode = Mode("report", 3)
        self.endmode = Mode("shutdown")
        self.reqmode = Mode("requests", 9)

        super(MediaServerProcess, self).__init__(name, directive)

    def setup(self):

        self.selector.modes = [self.startmode, self.evalmode, self.scanmode, self.matchmode, self.fixmode, self.reportmode, self.reqmode, self.endmode]
        self.selector.rules = [
            Rule('start -> scan', self.startmode, self.scanmode, self.can_scan, self.do_scan, self.before_scan, self.after_scan),
            Rule('start -> match', self.startmode, self.matchmode, self.can_match, self.do_match, self.before_match, self.after_match),
            Rule('start -> eval', self.startmode, self.evalmode, self.can_eval, self.do_eval, self.before, self.after_eval),
            Rule('eval -> scan', self.evalmode, self.scanmode, self.can_scan, self.do_scan, self.before_scan, self.after_scan),
            Rule('eval -> reqs', self.evalmode, self.reqmode, self.maybe, self.do_reqs, self.before, self.after),
            # Rule('eval -> shutdown', self.evalmode, self.endmode, self.can_shutdown, self.do_shutdown, self.before_shutdown, self.after_shutdown),
            Rule('reqs -> match', self.reqmode, self.matchmode, self.can_match, self.do_match, self.before_match, self.after_match),
            Rule('eval -> match', self.evalmode, self.matchmode, self.can_match, self.do_match, self.before_match, self.after_match),
            Rule('scan -> match', self.scanmode, self.matchmode, self.can_match, self.do_match, self.before_match, self.after_match),

            Rule('match -> match', self.matchmode, self.matchmode, self.can_match, self.do_match, self.before_match, self.after_match),
            Rule('match -> eval', self.matchmode, self.evalmode, self.can_eval, self.do_eval, self.before, self.after_eval),
            Rule('match -> scan', self.matchmode, self.scanmode, self.can_scan, self.do_scan, self.before_scan, self.after_scan),
            Rule('match -> report', self.matchmode, self.reportmode, self.can_report, self.do_report),
            # Rule('scan -> fix', scanmode, fixmode, self.can_fix, self.do_fix, self.before_fix, self.after_fix),
            # Rule('match -> fix', matchmode, fixmode, self.can_fix, self.do_fix, self.before_fix, self.after_fix),
            Rule('report -> eval', self.reportmode, self.evalmode, self.can_eval, self.do_eval, self.before, self.after_eval),
            Rule('report -> scan', self.reportmode, self.scanmode, self.can_scan, self.do_scan, self.before_scan, self.after_scan),
            Rule('report -> fix', self.reportmode, self.fixmode, self.can_fix, self.do_fix, self.before, self.after),
            # Rule('eval -> fix', self.evalmode, self.fixmode, self.can_fix, self.do_fix, self.before_fix, self.after_fix),
            Rule('fix -> shutdown', self.fixmode, self.endmode, self.can_shutdown, self.do_shutdown, self.before_shutdown, self.after_shutdown),
            Rule('fix -> eval', self.fixmode, self.evalmode, self.can_eval, self.do_eval, self.before, self.after_eval)
        ]

        self.directive.add_requirement('report frequently', self.definitely, self.do_report)

    def after_start(self): print "%s system started" % self.name

    def before_start(self): print "%s system starting" % self.name

    def started(self): print "%s system online" % self.name

    def after(self): print "_%s_ after '%s', because of '%s'" % (self.name, self.selector.previous.desc, self.selector.active.rule_applied.desc \
        if self.selector.active.rule_applied is not None else '...')
    
    def before(self): print "_%s_ before '%s'" % (self.name, self.selector.next.desc)

    def after_eval(self): 
        self.after()
        self.evalmode.priority -= 1
        
    def can_eval(self): return True
        # return True
        
    def do_eval(self): 
        print '%s evaluating' % self.name
        self.fixmode.priority += 1

    def after_fix(self):
        self.after()
        print '%s clearing caches' % self.name

    def before_fix(self):
        print '%s checking cache size'  % self.name

    def can_fix(self):
        return True
        
    def do_fix(self):
        print '%s writing data, generating work queue' % self.name
        self.scanmode.priority = 0
        self.matchmode.priority = 0
        self.evalmode.priority  = 0
        self.fixmode.priority  = 0
        self.reportmode.priority  = 0
        self.reqmode.priority  = 0

    def can_report(self):
        data = {'method': 'can_report', 'last_report': self.reportmode.last_active }
        return self.directive.applies(data)
            
    def do_report(self):
        
        # print '%s times_activated = %i, priority = %i ' % (self.mode.desc, self.mode.times_activated, self.mode.priority)
        print '%s generating match report' % self.name
        print '%s times_activated = %i, priority = %i ' % (self.scanmode.desc, self.scanmode.times_active, self.scanmode.priority)
        print '%s times_activated = %i, priority = %i ' % (self.matchmode.desc, self.matchmode.times_active, self.matchmode.priority)
        print '%s times_activated = %i, priority = %i ' % (self.reqmode.desc, self.reqmode.times_active, self.reqmode.priority)
        print '%s times_activated = %i, priority = %i ' % (self.evalmode.desc, self.evalmode.times_active, self.evalmode.priority)
        print '%s times_activated = %i, priority = %i ' % (self.fixmode.desc, self.fixmode.times_active, self.fixmode.priority)
        print '%s times_activated = %i, priority = %i ' % (self.reportmode.desc, self.reportmode.times_active, self.reportmode.priority)

        self.reportmode.priority -= 1
        self.fixmode.priority += 1
        
    def before_match(self):
        self.before()
        print '%s preparing for matching, caching data' % self.name

    def after_match(self):
        self.after()
        print '%s done matching, clearing cache...' % self.name
        self.reportmode.priority += 1

    def can_match(self):
        return True
        return config.match
        
    def do_match(self):
        print '%s matching...' % self.name
        self.matchmode.priority -= 1
        try:
            calc.calculate_matches(self.directive)
        except Exception, err:
            print err.message

    def do_reqs(self):
        print '%shandling requests...' % self.name
        self.reqmode.priority -= 1

    def before_scan(self):
        print '%s preparing to scan, caching data' % self.name

    def after_scan(self):
        self.after()
        print '%s done scanning, clearing cache...' % self.name
        self.scanmode.priority -= 1
        
    def can_scan(self):
        return True
        return config.scan
        # reasons for not scanning 
        # if ops_exist_for_all ::: current_directive_path

    def do_scan(self):
        print '%s scanning...' % self.name
        # try:
        #     scan.scan(self.directive)
        # except Exception, err:
        #     print err.message

    def can_shutdown(self):
        return True

    def after_shutdown(self):
        self.after()
        print '%s server process complete' % self.name

    def before_shutdown(self):
        print '%s handling shutdown request, clearing caches, writing data' % self.name

    def do_shutdown(self):
        if self.selector.complete:
            print '%s ending process...' % self.name

    def maybe(self):
        result = bool(random.getrandbits(1)) 
        return result

    def definitely(self, target):
        return True

def create_server_process(identifier, alternative=None):
    if alternative == None: 
        return MediaServerProcess(identifier)

    return alternative(identifier)

def main():
    random.seed()
    # demo()
    directive = direct.create(["/media/removable/Audio/music/albums/industrial"])
    MediaServerProcess('basic', directive).execute()

if __name__ == '__main__':
    main()
