'''
   Usage: util.py [(--delta <source> <target> (--remove-source | --dry-run))]

'''

import os, sys

from docopt import docopt

def str_clean4comp(input, *exception):
    alphanum = "0123456789abcdefghijklmnopqrstuvwxyz"
    for item in exception:
        alphanum += item
    return ''.join([letter.lower() for letter in input if letter.lower() in alphanum])

# compare source and target folders, remove files from source that exist in target
def delta(source, target, remove_source_files=False):
    for f in os.listdir(source):
        source_path = os.path.join(source, f)
        target_path = os.path.join(target, f)

        if os.path.isfile(source_path):
            if os.path.exists(target_path):
                if remove_source_files:
                    print 'deleting: %s' % (source_path)
                    os.remove(source_path)
                else: print 'file: %s also exists in %s' % (f, target)

        elif os.path.isdir(source_path):
            print 'folder: %s' % (source_path)
            if os.path.exists(target_path):
               delta(source_path, target_path, remove_source_files)

def main(args):
    if args['--delta']:
        source = args['<source>']
        target = args['<target>']
        if args['--remove-source']:
            delta(source, target, True)
        elif args['--dry-run']:
            delta(source, target, False)

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)


def smash(str):
    return str.lower().replace(' ', '').replace('_', '').replace(',', '').replace('.', '').replace(':', '')