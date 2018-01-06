'''
   Usage: launch.py [(--config <filename>)] [(--path <path>...) | (--pattern <pattern>...)] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--noflush] 
                    [--clearmem] [--checkforbugs] [--reset] [--exit] [--expand-all] [(--workdir <directory>)] [(--map-paths <startpath>)]

   --path, -p                   The path to scan

'''
import traceback

import datetime
import os
import sys

from docopt import docopt

import config
import core.var
import ops
import pathutil
import shallow
import start
import disc

from core.vector import PathVector, CachedPathVector
from core.serv import Service
from core import util

from shallow import get_locations

def get_process_create_func():
    proc_name = core.var.service_create_func.split('.')
    module_name =  proc_name[0]
    module = __import__(module_name)
    func = proc_name[1]
    create_func = getattr(module, func)

    return create_func


def launch(args, run=True):
    try:
        # NOTE: final changes to config here 
        config.config_file = config.config_file if not args['--config'] else args['<filename>']
        config.start_time = datetime.datetime.now().isoformat()
    
        start.execute(args)

        if config.started:
            service =  Service()

            if run:
                create_func = get_process_create_func()

                path_args = start.get_paths(args)
                paths = get_locations() if path_args == [] else path_args

                if paths == [] and args['--map-paths']:
                    startpath = args['<startpath>']
                    paths = disc.map(startpath)

                if paths == []:
                    sys.exit("ERROR: No paths have been configured. Restart with --map-paths option")                   

                vector = CachedPathVector('path vector', paths)
                vector.peep_fifo = True
                if args['--expand-all']:
                    vector.set_param('all', 'expand-all', True)

                if args['--map-paths']:
                    vector.set_param('all', 'map-paths', True)
                    vector.set_param('all', 'start-path', args['<startpath>'])

                process = create_func('service process', vector, service, before=before, after=after)    
                service.queue([process])
                # TODO: a call to service.handle_processes() should NOT be required here or anywhere else outside of the service process
                service.handle_processes()

            return service

        else: raise Exception('unable to initialize with current configuration in %s.' % config.filename)
    except Exception, err:
        traceback.print_exc()
        sys.exit(err.message)

def after(process):
    print('%s has ended.' % process.name)
    

def before(process):
    print('%s starting...' % process.name)
    ops.record_exec()
    

def main(args):
    os.chdir(util.get_working_directory())
    launch(args)


if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
