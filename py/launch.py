'''
   Usage: launch.py [(--config <filename>)] [(--path <path>...) | (--pattern <pattern>...) ] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--noflush] [--clearmem] [--checkforbugs] 

   --path, -p                   The path to scan

'''

import datetime
from docopt import docopt

import config, direct, serv, start, ops
from serv import Server, ServerProcess
from mediaserv import MediaServerProcess
from direct import Directive

def create_server_process(identifier, directive, alternative_creator=None):
    if alternative_creator == None: 
        return MediaServerProcess(identifier, directive)
    else: return alternative_creator(identifier)

def launch(args, run=True):
    try:
        # NOTE: final changes to config
        config.filename = config.filename if not args['--config'] else args['<filename>'] 
        config.start_time = datetime.datetime.now().isoformat() 
        start.execute(args)   
        if not config.launched: raise Exception('unable to initialize with current configuration in %s.' % config.filename)
        
        server =  Server()
        ops.record_exec()
        
        if run:
            paths = start.get_paths(args)
            directive = direct.create(paths)
            process_name = None if not args['--process'] else args['<process_name>'] 
            process = create_server_process(process_name, directive)

            server.run(process, directive)
                        
        return server

    except Exception, err:
        print err.message

def after (process):
    print '%s after launch' % process.name

def before(process):
    print '%s before launch' % process.name

def main(args):
    server = launch(args, False)
    if server is not None:
        directive = direct.create(start.get_paths(args))
        server.run(create_server_process('Default', directive), True, before, after)
        server.run(create_server_process('Sleeper', directive), True)
        a = create_server_process('Cleaning the system', directive)
        # a.after = after
        b = create_server_process('Scanning new install', directive)
        c = create_server_process('Matching and Reporting', directive)
        server.queue([a, b, c])
        server.handle_processes()


if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
