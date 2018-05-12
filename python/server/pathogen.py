"""pathogen is a wrapper around the mutagen API"""

import os, json, sys, logging, traceback, time, datetime, traceback

from mutagen import MutagenError
from mutagen.id3 import ID3, ID3NoHeaderError
from mutagen.flac import FLAC, FLACNoHeaderError, FLACVorbisError
from mutagen.apev2 import APEv2, APENoHeaderError, APEUnsupportedVersionError
from mutagen.oggvorbis import OggVorbis, OggVorbisHeaderError
from mutagen.mp4 import MP4, MP4MetadataError, MP4MetadataValueError, MP4StreamInfoError

import const, ops

import filehandler
from filehandler import FileHandler
from const import MAX_DATA_LENGTH
from core import log, util
from core.errors import BaseClassException

from ops import ops_func

LOG = log.get_safe_log(__name__, logging.INFO)
ERR = log.get_safe_log('errors', logging.WARNING)


class Pathogen(FileHandler):
    def __init__(self, name):
        super(Pathogen, self).__init__(name)
        self.tags = {}
        
    def key_is_invalid(self, key):
        if '.' in key or len(key) == 0: 
            return True

    #TODO: decorate this method with error handling that will deal properly with trapping UnicodeDecodeError 
    @ops_func
    def handle_file(self, path, data):
        LOG.info("%s reading file: %s" % (self.name, path))
        read_failed = False

        try:
            ops.record_op_begin(path, const.READ, self.name)
            self.tags = {}
            self.read_tags(path, data)
            return True

        except ID3NoHeaderError, err:
            read_failed = True
            self.tags['_ERROR'] = err.__class__.__name__

        except UnicodeEncodeError, err:
            read_failed = True
            self.tags['_ERROR'] = err.__class__.__name__

        except UnicodeDecodeError, err:
            read_failed = True
            self.tags['_ERROR'] = err.__class__.__name__

        except FLACNoHeaderError, err:
            read_failed = True
            self.tags['_ERROR'] = err.__class__.__name__

        except FLACVorbisError, err:
            read_failed = True
            self.tags['_ERROR'] = err.__class__.__name__

        except APENoHeaderError, err:
            read_failed = True
            self.tags['_ERROR'] = err.__class__.__name__

        except OggVorbisHeaderError, err:
            read_failed = True
            self.tags['_ERROR'] = err.__class__.__name__

        except MP4MetadataError, err:
            read_failed = True
            self.tags['_ERROR'] = err.__class__.__name__

        # except MP4MetadataValueError, err:
        #     read_failed = True
        #     self.tags['_ERROR'] = err.__class__.__name__

        except MP4StreamInfoError, err:
            read_failed = True
            self.tags['_ERROR'] = err.__class__.__name__

        except MutagenError, err:
            ERR.error(err.__class__.__name__)
            if isinstance(err.args[0], IOError):
                fs_avail = False
                while fs_avail is False:
                    #TODO: add a timeout to recovery attempts
                    print("file system offline, retrying in 5 seconds...") 
                    time.sleep(5)
                    fs_avail = os.access(path, os.R_OK) 

                print("resuming...") 
                self.read_tags(path, data)
                return True

        except Exception, err:
            ERR.error(err.message)
            read_failed = True
            self.tags['_ERROR'] = err.__class__.__name__

        finally:
            ops.record_op_complete(path, const.READ, self.name, op_failed=read_failed)
            if read_failed:
                self.tags['_reader'] = self.name
                data['attributes'].append(self.tags)
                

    def read_tags(self, path, data):
        raise BaseClassException(Pathogen)


class MutagenAAC(Pathogen):
    def __init__(self):
        super(MutagenAAC, self).__init__('mutagen-aac')


# class MutagenM4A(Pathogen):
#     def __init__(self):
#         super(MutagenM4A, self).__init__('mutagen-m4a')


class MutagenMP4(Pathogen):
    def __init__(self):
        super(MutagenMP4, self).__init__('mutagen-mp4')

    def read_tags(self, path, data):
        filename, file_extension = os.path.splitext(path)
        file = MP4(path)
        for item in file.items():
            if len(item) < 2: 
                continue

            key = util.uu_str(item[0].lower()).replace(u'\xa9', '')
            if self.key_is_invalid(key): 
                continue
            
            self.handle_attribute(file_extension, key)

            if isinstance(item[1], bool):
                value = item[1]
            elif isinstance(item[1],(list, tuple)):
                if isinstance(item[1][0], basestring):
                    value = util.uu_str(item[1][0])
                else:
                    value = item[1][0]


            if isinstance(value, unicode) and len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_attribute(path, key, value)
                continue

            self.tags[key] = util.uu_str(value)

        if len(self.tags) > 0:
            self.tags['_file_encoding'] = file_extension
            self.tags['_reader'] = self.name
            #TODO: store read_date in same format as file ctime and mtime
            self.tags['_read_date'] = datetime.datetime.now().isoformat()
            data['attributes'].append(self.tags)


class MutagenOggFlac(Pathogen):
    def __init__(self):
        super(MutagenOggFlac, self).__init__('mutagen-oggflac')


class MutagenAPEv2(Pathogen):
    def __init__(self):
        super(MutagenAPEv2, self).__init__('mutagen-apev2')

    def read_tags(self, path, data):
        filename, file_extension = os.path.splitext(path)
        file = APEv2(path)
        for item in file.items():
            if len(item) < 2: 
                continue

            key = util.uu_str(item[0].lower())
            if self.key_is_invalid(key):
                continue

            self.handle_attribute(file_extension, key)

            value = util.uu_str(item[1].value)
            if len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_attribute(path, key, value)
                continue

            self.tags[key] = value

        if len(self.tags) > 0:
            self.tags['_file_encoding'] = file_extension
            self.tags['_reader'] = self.name
            self.tags['_read_date'] = datetime.datetime.now().isoformat()
            data['attributes'].append(self.tags)


class MutagenFLAC(Pathogen):
    def __init__(self):
        super(MutagenFLAC, self).__init__('mutagen-flac')

    def read_tags(self, path, data):
        filename, file_extension = os.path.splitext(path)
        file = FLAC(path)
        for tag in file.tags:
            if len(tag) < 2: continue

            key = tag[0].lower()  #util.uu_str(tag[0])
            if self.key_is_invalid(key):
                continue

            self.handle_attribute(file_extension, key)

            value = util.uu_str(tag[1])
            if len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_attribute(path, key, value)
                continue
            self.tags[key] = value


        for tag in file.vc:
            key = util.uu_str(tag[0].lower())
            if self.key_is_invalid(key):
                continue

            self.handle_attribute(file_extension, key)

            value = util.uu_str(tag[1])
            if len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_attribute(path, key, value)
                continue

            if key not in self.tags:
                self.tags[key] = value

        if len(self.tags) > 0:
            self.tags['_file_encoding'] = file_extension
            self.tags['_reader'] = self.name
            self.tags['_read_date'] = datetime.datetime.now().isoformat()
            data['attributes'].append(self.tags)


class MutagenID3(Pathogen):
    def __init__(self):
        super(MutagenID3, self).__init__('mutagen-id3')

    def read_tags(self, path, data):
        file = ID3(path)
        version = '.'.join([str(value) for value in file.version])
        file_encoding = 'ID3v%s' % version

        metadata = file.pprint() # gets all metadata
        tags = [x.split('=',1) for x in metadata.split('\n')] # substring[0:] is redundant

        for tag in tags:
            if len(tag) < 2: 
                continue

            key = util.uu_str(tag[0].lower())
            if self.key_is_invalid(key): 
                continue

            if len(key) == 4 and key != "TXXX":
                self.handle_attribute(file_encoding, key)

            value = util.uu_str(tag[1])
            if value is None:
                continue

            if len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_attribute(path, key, value)
                continue
            
            if key == u"TXXX":
                if not key in self.tags:
                    # self.tags[key] = []   
                    self.tags[key] = {}   

                subtags = value.split('=')
                subkey = util.uu_str(subtags[0].replace('"', '').replace(' ', '_').lower())
                if self.key_is_invalid(subkey): 
                    continue
                
                txxkey = '.'.join([key, subkey]).lower()
                self.handle_attribute(file_encoding, txxkey)
                self.tags[key][subkey] = util.uu_str(subtags[1])

            else:
                # if key in filehandler.get_attributes(file_encoding):
                self.tags[key] = util.uu_str(value)

        if len(self.tags) > 0:
            self.tags['_file_encoding'] = file_encoding
            self.tags['_reader'] = self.name
            self.tags['_read_date'] = datetime.datetime.now().isoformat()
            data['attributes'].append(self.tags)


class MutagenOggVorbis(Pathogen):
    def __init__(self):                
        super(MutagenOggVorbis, self).__init__('mutagen-oggvorbis')

    def read_tags(self, path, data):
        filename, file_extension = os.path.splitext(path)
        file = OggVorbis(path)
        tags = file.tags.as_dict()
        for tag in tags:
            if len(tag) < 2:
                continue

            key = util.uu_str(tag.lower())
            if self.key_is_invalid(key): 
                continue

            self.handle_attribute(file_extension, key)

            value = util.uu_str(tags[tag])
            if len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_attribute(path, key, value)
                continue

            self.tags[key] = value[0]

        if len(self.tags) > 0:
            self.tags['_file_encoding'] = file_extension
            self.tags['_reader'] = self.name
            self.tags['_read_date'] = datetime.datetime.now().isoformat()
            data['attributes'].append(self.tags)


