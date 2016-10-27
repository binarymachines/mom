'''
   Usage: util.py [(--delta <source> <target> (--remove-source | --dry-run))]

'''

import os

from docopt import docopt

# def caller_directory():
#     mod_name = inspect.currentframe().f_back.f_back.f_globals.get('__name__')
#     module = sys.modules[mod_name]
#     if not hasattr(module, '__file__'): #probably REPL
#         return os.getcwd()
#     path = module.__file__
#     #now, where does this path meet the python path?
#     if os.path.isabs(path): #already absolute path? hurray, we are done
#         return os.path.dirname(path)
#     #otherwise, need to go down the python path finding where it joins
#     for p in sys.path:
#         p = os.path.join(p, path)
#         if os.path.exists(p):
#             return os.path.dirname(os.path.abspath(p))
#     raise Exception("could not find caller directory")


# compare source and target s, remove files from source that exist in target
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
            print ': %s' % (source_path)
            if os.path.exists(target_path):
               delta(source_path, target_path, remove_source_files)

def get_working_directory():
    coredir = os.path.abspath(os.path.join(__file__, os.pardir))
    pydir = os.path.abspath(os.path.join(coredir, os.pardir))
    workdir = os.path.abspath(os.path.join(pydir, os.pardir))

    return workdir


def smash(str):
    return str.lower().replace(' ', '').replace('_', '').replace(',', '').replace('.', '').replace(':', '')
    

def str_clean4comp(input, *exception):
    alphanum = "0123456789abcdefghijklmnopqrstuvwxyz"
    for item in exception:
        alphanum += item

    return ''.join([letter.lower() for letter in input if letter.lower() in alphanum])


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
