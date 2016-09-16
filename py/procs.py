'''
   Usage: serve.py [(--config <filename>)] [(--path <path>...) | (--pattern <pattern>...) ] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--noflush] [--clearmem] [--checkforbugs] 

   --path, -p                   The path to scan

'''

import os, sys
from docopt import docopt

import serv

from serv import ServerProcess
from mediaserv import MediaServerProcess
from direct import Directive

def create_server_process(identifier, alternative_creator=None):
    if identifier == 'basic': 
        return MediaServerProcess()

    elif alternative_creator != None: return alternative_creator(identifier)

def main(args):
    server = serv.launch(args, False)
    if server is not None:
        process = create_server_process('basic')
        if process is not None:
            directive = direct.create(start.get_paths(args))
            server.run(process, directive)

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
