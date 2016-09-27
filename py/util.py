#! /usr/bin/python

import os, sys

def str_clean4comp(input):
    alphanum = "0123456789abcdefghijklmnopqrstuvwxyz"
    return ''.join([letter.lower() for letter in input if letter in alphanum])

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

def main():
    source = '/media/removable/Audio/music [bak]/slsk-complete'
    target = '/media/removable/SEAGATE 932/media/music/incoming/complete'
    delta(source, target, True)

if __name__ == '__main__':
    main()