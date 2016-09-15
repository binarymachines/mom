import random

from modes import Mode, Selector, Rule, Machine 

import config, direct, library, calc, scan, filter

from direct import Directive

class ServerProcess(object):
    def __init__(self, name=None):
        self.name = "\n%\`]" if name is None else name
        self.selector = Selector(self.name)
        self.machine = Machine();
        self.setup()
        self.selector.start = self.selector.modes[0]
        self.selector.end = self.selector.modes[-1]        
        self.machine.add(self.selector)
        self.directive = None
    
    def setup(self):
        raise Exception("Not Implemented.")

    def execute(self, directive):
        self.directive = directive
        self.machine.execute()
        
    def step(self):
        self.machine.step()

class MediaServerProcess(ServerProcess):
    def __init__(self, name=None):

        self.startmode = Mode("startup", 0, self.started, self.before_start, self.after_start)
        self.evalmode = Mode("eval", 6)
        self.scanmode = Mode("scan", 7)
        self.matchmode = Mode("match", 5)
        self.fixmode = Mode("fix", 1)
        self.filtermode = Mode("filter", 3)
        self.endmode = Mode("shutdown")
        self.reqmode = Mode("requests", 9)

        super(MediaServerProcess, self).__init__(name)

    def setup(self):

        self.selector.modes = [self.startmode, self.evalmode, self.scanmode, self.matchmode, self.fixmode, self.filtermode, self.reqmode, self.endmode]
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
            Rule('match -> eval', self.matchmode, self.evalmode, self.can_eval, self.do_eval, self.before, self.after_eval),
            Rule('match -> scan', self.matchmode, self.scanmode, self.can_scan, self.do_scan, self.before_scan, self.after_scan),
            Rule('match -> filter', self.matchmode, self.filtermode, self.can_filter, self.do_filter),
            # Rule('scan -> fix', scanmode, fixmode, self.can_fix, self.do_fix, self.before_fix, self.after_fix),
            # Rule('match -> fix', matchmode, fixmode, self.can_fix, self.do_fix, self.before_fix, self.after_fix),
            Rule('filter -> eval', self.filtermode, self.evalmode, self.can_eval, self.do_eval, self.before, self.after_eval),
            Rule('filter -> fix', self.filtermode, self.fixmode, self.can_fix, self.do_fix, self.before, self.after),
            Rule('eval -> fix', self.evalmode, self.fixmode, self.can_fix, self.do_fix, self.before_fix, self.after_fix),
            Rule('fix -> shutdown', self.fixmode, self.endmode, self.can_shutdown, self.do_shutdown, self.before_shutdown, self.after_shutdown)
        ]

    def after_start(self): print "system started"

    def before_start(self): print "system starting"

    def started(self): print "system online"

    def after(self): print "after '%s', because of '%s'" % (self.selector.previous.desc, self.selector.active.rule_applied.desc \
        if self.selector.active.rule_applied is not None else '...')
    
    def before(self): print "before '%s'" % self.selector.next.desc

    def after_eval(self): 
        self.after()
        self.evalmode.priority -= 1
        
    def can_eval(self): return True
        # return True
        
    def do_eval(self): 
        print 'evaluating'
        self.fixmode.priority += 1

    def after_fix(self):
        self.after()
        print 'clearing caches'

    def before_fix(self):
        print 'checking cache size'

    def can_fix(self):
        return True
        
    def do_fix(self):
        print 'writing data, generating work queue'
        self.scanmode.priority += 1
        self.matchmode.priority += 1

    def can_filter(self):
        return self.maybe()
        
    def do_filter(self):
        self.matchmode.priority += 1
        print 'generating match report'

    def before_match(self):
        self.before()
        print 'preparing for matching, caching data'

    def after_match(self):
        self.after()
        print 'done matching, clearing cache...'
        self.filtermode.priority += 1

    def can_match(self):
        return True
        return config.match
        
    def do_match(self):
        print 'matching...'
        self.matchmode.priority -= 1
        # try:
        #     calc.calculate_matches(self.directive)
        # except Exception, err:
            # print err.message

    def do_reqs(self):
        print 'handling requests...'
        self.reqmode.priority -= 1

    def before_scan(self):
        print 'preparing to scan, caching data'

    def after_scan(self):
        self.after()
        print 'done scanning, clearing cache...'
        self.scanmode.priority -= 1
        
    def can_scan(self):
        return True
        return config.scan
        # reasons for not scanning 
        # if ops_exist_for_all ::: current_directive_path

    def do_scan(self):
        print 'scanning...'
        # try:
        #     scan.scan(self.directive)
        # except Exception, err:
        #     print err.message

    def can_shutdown(self):
        return True

    def after_shutdown(self):
        self.after()
        print 'server process complete'

    def before_shutdown(self):
        print 'handling shutdown request, clearing caches, writing data'

    def do_shutdown(self):
        if self.selector.complete:
            print 'ending process...'

    def maybe(self):
        result = bool(random.getrandbits(1)) 
        return result

def main():
    random.seed()
    # demo()
    MediaServerProcess().execute(direct.create(["/media/removable/Audio/music/albums/industrial"]))

if __name__ == '__main__':
    main()
