'''
   Usage: launch.py [(--config <filename>)] [(--path <path>...) | (--pattern <pattern>...)] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--noflush] 
                    [--clearmem] [--checkforbugs] [--reset] [--exit] [--expand-all] [(--workdir <directory>)]

   --path, -p                   The path to scan

'''

import datetime
import os
import subprocess
from docopt import docopt

import config
import core.var
import ops
import pathutil
import start

from core.context import DirectoryContext
from core.serv import Service
from core import util
from core import var


def get_process_create_func():
    proc_name = core.var.service_create_func.split('.')
    module_name =  proc_name[0]
    module = __import__(module_name)
    func = proc_name[1]
    create_func = getattr(module, func)

    return create_func


def launch(args, run=True):
    try:
        # TODO: set vars.workdir BEFORE any calls to log.start_logging() are made 
        # vars.workdir = util.get_working_directory() if not args['--workdir'] else args['<directory>']

        # NOTE: final changes to config happen here
        
        config.filename = config.filename if not args['--config'] else args['<filename>']
        config.start_time = datetime.datetime.now().isoformat()
        start.execute(args)

        if config.launched:
            service =  Service()

            if run:
                create_func = get_process_create_func()

                path_args = start.get_paths(args)
                paths = pathutil.get_locations() if path_args == [] else path_args

                context = DirectoryContext('path context', paths)
                context.peep_fifo = True
                if args['--expand-all']:
                    context.set_param('all', 'expand_all', True)

                process = create_func('MILDRED', context)
                process.after = after
                process.before = before

                ops.record_exec()
    
                service.queue(process)
                # TODO: a call to service.handle_processes() should NOT be required here or anywhere else outside of the service process
                service.handle_processes()

            return service

        else: raise Exception('unable to initialize with current configuration in %s.' % config.filename)
    except Exception, err:
        print err.message


def after (process):
    print '%s after launch' % process.name


def before(process):
    print '%s before launch' % process.name


def main(args):
    # subprocess.Popen([util.get_kivy_directory(), 'cachemon.py', '--size=1200x100'], shell=True)

    os.chdir(util.get_working_directory())
    service = launch(args)


    # service = launch(args, run=False)
    # if service is not None:
    #     try:
    #         create_func = get_process_create_func()

    #         path_args = start.get_paths(args)
    #         paths = pathutil.get_locations() if path_args is None else path_args

    #         context = DirectoryContext('path context', paths)
    #         if args['--expand-all']:
    #             context.set_param('all', 'expand_all', True)

    #         directive = direct.create(paths)

    #         a = create_func('a service', context)
    #         a.after = after
    #         a.before = before
    #         # b = create_func('b service', context)
    #         # c = create_func('c service', context)

    #         service.queue(a)

    #         # TODO: a call to service.handle_processes() should NOT be required here or anywhere else outside of the service process
    #         service.handle_processes()

    #         # TODO: tests with threaded services reveals design/implementation flaws
    #         # service.run(create_func('Threaded worker', context), True, before, after)
    #         # service.run(create_func('Threaded sleeper', context), True)
    #     except Exception, err:
    #         print 'Unable to create process due to %s' % err.message

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
