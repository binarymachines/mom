#! /usr/bin/python

'''
   Usage: serve.py [(--path <path>...) | (--pattern <pattern>...) ] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--noflush] [--clearmem] [--checkforbugs]

   --path, -p                   The path to scan

'''

import os, sys,logging, traceback, thread

from docopt import docopt

import cache, config, start, ops

from asset import AssetException, Asset, MediaFile, MediaFile
from folders import MediaFolderManager
from read import Param, Reader
from walk import MediaLibraryWalker
from scan import Scanner

def ServerProcess():
    def run(self, param):
        if config.scan:
            scanner = Scanner()
            for location in param.locations:
                if os.path.isdir(location) and os.access(location, os.R_OK):
                    cache.cache_docs(config.MEDIA_FILE, path)

                    ops.cache_ops(path, 'scan', 'mp3 reader')
                    scanner.walk(location)

                    # self.location_cache = {}
                elif config.mfm_debug:  print "%s isn't currently available." % (location)

            print '\n-----scan complete-----\n'

        if config.match:
            calc.calculate_matches(param)

def execute(path=None):
    
    print 'Setting up scan param...'
    param = Param()

    param.extensions = ['mp3'] # util.get_active_media_formats()
    if path == None:
        for location in config.locations: 
            if location.endswith("albums") or location.endswith("compilations"):
                for genre in config.genre_folders:
                    param.locations.append(os.path.join(location, genre))
            else:
                param.locations.append(location)            

        for location in config.locations_ext: 
            param.locations.append(location)            
            
        param.locations.append(config.NOSCAN)
        # s.locations.append(config.EXPUNGED)
        
        # In mode 2, after running this mode to completion, query all locations that are not in op_records data
        # for location in config.locations: 
        #     param.locations.append(location)            
    else:
        for directory in path:
            param.locations.append(directory)

    param.locations.sort()

    print 'Configuring...'
    mfm = ServerProcess();
    print 'starting...'
    mfm.run(param)

def main(args):
    start.execute(start.make_options(args))

    path = None if not args['--path'] else args['<path>']
    pattern = None if not args['--pattern'] else args['<pattern>']
   
    if args['--pattern']:
        path = []
        for p in pattern:
            q = """SELECT absolute_path FROM es_document WHERE absolute_path LIKE "%s%s%s" AND doc_type = "%s" ORDER BY absolute_path""" % \
                ('%', p, '%', config.MEDIA_FOLDER)
            
            rows = mySQL.run_query(q)
            for row in rows: 
                path.append(row[0])

    execute(path)

# main
if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
