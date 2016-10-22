'''
   Usage: launch.py [(--config <filename>)] [(--path <path>...) | (--pattern <pattern>...)] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--noflush] [--clearmem] [--checkforbugs] [--reset] [--exit]

   --path, -p                   The path to scan

'''

import datetime, sys, os

from docopt import docopt

import config
import docserv
import start
import ops
import pathutil
import search
import sql
import util

from serv import Service

from context import DirectoryContext

def launch(args, run=True):
    try:
        # NOTE: final changes to config happen here
        config.filename = config.filename if not args['--config'] else args['<filename>']
        config.start_time = datetime.datetime.now().isoformat()
        start.execute(args)

        if config.launched:
            ops.record_exec()
            service =  Service()

            if run:
                paths = start.get_paths(args)
                context = DirectoryContext('_path_context_', paths)
                context.peep_fifo = True
                # directive = direct.create(paths)
                process_name = None if not args['--process'] else args['<process_name>']
                process = docserv.create_service_process(process_name, context)

                service.run(process, context)

            return service

        else: raise Exception('unable to initialize with current configuration in %s.' % config.filename)
    except Exception, err:
        print err.message


def after (process):
    print '%s after launch' % process.name


def before(process):
    print '%s before launch' % process.name


def main(args):
    pydir = os.path.abspath(os.path.join(__file__, os.pardir))
    workdir = os.path.abspath(os.path.join(pydir, os.pardir))
    os.chdir(workdir)
    
    service = launch(args, run=False)
    if service is not None:
        try:
            create_proc = docserv.create_service_process

            path_args = start.get_paths(args)
            paths = pathutil.get_locations() if path_args is None else path_args

            context = DirectoryContext('path context', paths)

            a = create_proc('a service', context)
            a.after = after
            a.before = before
            # b = create_proc('b service', context)
            # c = create_proc('c service', context)

            service.queue(a)

            # TODO: a call to service.handle_processes() should NOT be required here or anywhere else outside of the service process
            service.handle_processes()

            # TODO: tests with threaded services reveals design/implementation flaws
            # service.run(create_proc('Threaded worker', context), True, before, after)
            # service.run(create_proc('Threaded sleeper', context), True)
        except Exception, err:
            print 'Unable to create process due to %s' % err.message

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
