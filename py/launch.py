'''
   Usage: launch.py [(--config <filename>)] [(--path <path>...) | (--pattern <pattern>...)] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--noflush] [--clearmem] [--checkforbugs]

   --path, -p                   The path to scan

'''

import datetime

from docopt import docopt

import config, docserv, start, ops, library
import ops2
import pathutil
import search
import sql
from serv import Service

from context import DirectoryContext

def launch(args, run=True):
    try:
        # NOTE: final changes to config happen here
        config.filename = config.filename if not args['--config'] else args['<filename>']
        config.start_time = datetime.datetime.now().isoformat()
        start.execute(args)

        if config.launched:

            service =  Service()
            ops2.record_exec()

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


def reset():
    if config.es.indices.exists(config.es_index):
        search.clear_index(config.es_index)

    if not config.es.indices.exists(config.es_index):
        search.create_index(config.es_index)

    config.redis.flushdb()
    for table in ['es_document', 'op_record', 'problem_esid', 'problem_path', 'matched']:
        query = 'delete from %s where 1 = 1' % (table)
        sql.execute_query(query)


def main(args):
    service = launch(args, run=False)
    if service is not None:
        try:
            create_proc = docserv.create_service_process
            path_args = start.get_paths(args)
            context = DirectoryContext('path context', pathutil.get_locations() if path_args is None else path_args)
            context.peep_fifo = True

            a = create_proc('a service', context)
            a.after = after
            a.before = before
            # b = create_proc('b service', context)
            # c = create_proc('c service', context)

            reset()
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
