'''
   Usage: util.py [(--delta <source> <target> (--remove-source | --dry-run))]

'''

import os
import sys
import types

from docopt import docopt

import var

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

def str_to_class(self, objectTypeName):
    """A rudimentary class loader function.

    Arguments:
    objectTypeName -- a fully qualified name for the class to be loaded,
    in the form 'packagename.classname'.

    Returns:
    a Python Class object.
    """

    if objectTypeName.count('.') == 0:
        moduleName = __name__
        typeName = objectTypeName
    else:
        tokens = objectTypeName.rsplit('.', 1)
        moduleName = tokens[0]
        typeName = tokens[1]

    try:
        identifier = getattr(sys.modules[moduleName], typeName)
    except AttributeError:
        raise NameError("Class %s doesn't exist." % objectTypeName)
    if isinstance(identifier, (types.ClassType, types.TypeType)):
        return identifier
    raise TypeError("%s is not a class." % objectTypeName)


# compare source and targets, remove files from source that exist in target
def delta(source, target, remove_source_files=False):
    print source
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
    if var.workdir is None:
        coredir = os.path.abspath(os.path.join(__file__, os.pardir))
        pydir = os.path.abspath(os.path.join(coredir, os.pardir))
        nominalresult = os.path.abspath(os.path.join(pydir, os.pardir))

        # cwd = os.getcwd()
        # if cwd != nominalresult:
        #     response = raw_input('Do you want to run application in %s? (yes, no): ' % cwd)
        #     if response.lower() == 'no':
        #         var.workdir = nominalresult
        # else:
        #     prep_work_dir(cwd)

        var.workdir = nominalresult

    return var.workdir

def mkdirs(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)


def prep_work_dir(workdir):
    dirs = os.listdir(workdir)
    if not 'log' in dirs:
        log = os.path.join(workdir, 'log')
        mkdirs(log)

    if not 'tmp' in dirs:
        tmp = os.path.join(workdir, 'tmp')
        mkdirs(tmp)

    if not 'bak' in dirs:
        bak = os.path.join(workdir, 'bak')
        mkdirs(bak)

    coredir = os.path.abspath(os.path.join(__file__, os.pardir))
    pydir = os.path.abspath(os.path.join(coredir, os.pardir))
    var.sqldir = os.path.join(pydir, 'sql')

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
