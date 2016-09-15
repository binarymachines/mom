#! /usr/bin/python

'''
   Usage: serve.py [(--config <filename>)] [(--path <path>...) | (--pattern <pattern>...) ] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--noflush] [--clearmem] [--checkforbugs] 

   --path, -p                   The path to scan

'''

import os, sys, logging, traceback, thread, subprocess

from docopt import docopt

import config, direct, start, sql

from direct import Directive
from proc import MediaServerProcess

class Server(object):
    def __init__(self):
        self.process = None
    
    def run(self, directive, process):
        self.process = process
        self.process.execute(directive)
        
    # In mode 2, after running this mode to completion, query all locations that are not in op_records data
    # directive.locations.append(location for location in config.locations)            

def launch(args):
    try:
        configfile = None if not args['--config'] else args['<filename>'] 
        if configfile: config.filename = configfile
        start.execute(start.make_options(args))

        paths = None if not args['--path'] else args['<path>']
        pattern = None if not args['--pattern'] else args['<pattern>']
    
        if args['--pattern']:
            for p in pattern:
                q = """SELECT absolute_path FROM es_document WHERE absolute_path LIKE "%s%s%s" AND doc_type = "%s" ORDER BY absolute_path""" % \
                    ('%', p, '%', config.MEDIA_FOLDER)
                for row in sql.run_query(q):
                    paths.append(row[0])

        if config.launched:
            print 'starting...'
            ops.record_exec()
            Server().run(direct.create(paths), MediaServerProcess())
        else: 
            message = 'unable to initialize with current configuration in %s.' % config.filename
    except Exception, err:
        print err.message
    # finally:
    #     Server().run(direct.create(paths), MediaServerProcess())
        
# main
def main(args):
    launch(args)

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
