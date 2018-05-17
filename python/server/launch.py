'''
   Usage: launch.py [(--config <filename>)] [(--path <path>...) | (--pattern <pattern>...)] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--noflush] 
                    [--clearmem] [--reset] [--exit] [--expand-all] [(--workdir <directory>)] [(--map-paths <startpath>)] [(--scan-path) <scanpath>]

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
import shallow
import start
import disc

from core.vector import PathVector, CachedPathVector
from core.serv import Service
from core import util

from shallow import get_directories

from alchemy import SQLServiceProfile

from core import serv
from service import ServiceProcess

def get_process_create_func(profile):
    module_name =  profile.service_handler_dispatch.module_name
    module = __import__(module_name)
    create_func = getattr(module, profile.service_handler_dispatch.func_name)

    return create_func


def launch(args, run=True):
    try:
        # config.config_file = config.config_file if not args['--config'] else args['<filename>']
    
        start.execute(args)

        if config.started:
            service = Service()

            profile = SQLServiceProfile.retrieve(core.var.profile)
            if profile and run:
                if args['--scan-path']:
                    paths = [args['<scanpath>']]
                else:
                    path_args = start.get_paths(args)
                    paths = get_directories() if path_args == [] else path_args

                vector = CachedPathVector('path vector', paths)
                vector.peep_fifo = True
                if args['--expand-all']:
                    vector.set_param('all', 'expand-all', True)

                if args['--map-paths']:
                    vector.set_param('all', 'map-paths', True)
                    vector.set_param('all', 'start-path', args['<startpath>'])

                service_process = ServiceProcess(vector, service, before=before, after=after)    
                service.queue([service_process])
                # TODO: a call to service.handle_services() should NOT be required here or anywhere else outside of the service process
                service.handle_services()

            return service

        else: raise Exception('unable to initialize with current configuration.')
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
