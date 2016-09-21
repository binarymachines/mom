'''
   Usage: launch.py [(--config <filename>)] [(--path <path>...) | (--pattern <pattern>...) ] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--noflush] [--clearmem] [--checkforbugs] 

   --path, -p                   The path to scan

'''

import datetime
from docopt import docopt

import config, direct, serv, mediaserv, start, ops, library
from serv import Service, ServiceProcess
from mediaserv import MediaServiceProcess
from context import PathContext

def get_path_config():
    result = [] 
    result.append([location for location in library.get_locations()])            
    result.append([location for location in library.get_locations_ext()])            
    result.sort()
    return result

def launch(args, run=True):
    try:
        # NOTE: final changes to config
        config.filename = config.filename if not args['--config'] else args['<filename>'] 
        config.start_time = datetime.datetime.now().isoformat() 
        start.execute(args) 
          
        if config.launched: 
        
            service =  Service()
            ops.record_exec()
            
            if run:
                paths = start.get_paths(args)
                context = Pathcontext('_path_context_', paths, ['mp3'])
                # directive = direct.create(paths)
                process_name = None if not args['--process'] else args['<process_name>'] 
                process = create_service_process(process_name, context)

                service.run(process, directive)
                            
            return service

        else: raise Exception('unable to initialize with current configuration in %s.' % config.filename)
    except Exception, err:
        print err.message

def after (process):
    print '%s after launch' % process.name

def before(process):
    print '%s before launch' % process.name

def main(args):
    service = launch(args, False)
    if service is not None:
        try:
            create_proc = mediaserv.create_service_process
            path_args = start.get_paths(args)
            context = PathContext('_path_context_', get_path_config() if path_args is None else path_args, ['mp3'])
        
            # service.run(create_proc('Threaded worker', context), True, before, after)
            # service.run(create_proc('Threaded sleeper', context), True)
            a = create_proc('Scanner', context)
            # a.after = after
            b = create_proc('Matcher', context)
            c = create_proc('Cleaner', context)
            service.queue(a)
            service.handle_processes()
        except Exception, err:
            print 'Unable to create process due to %s' % err.message

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
