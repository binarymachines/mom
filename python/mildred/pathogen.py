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


LOG = log.get_log(__name__, logging.INFO)
ERR = log.get_log('errors', logging.WARNING)


class Pathogen(FileHandler):
    def __init__(self, name):
        super(Pathogen, self).__init__(name)

    def handle_file(self, path, data):
        # LOG.info("%s reading file: %s" % (self.name, path))
        read_failed = False

        try:
            ops.record_op_begin(const.READ, self.name, path)            
            self.read_tags(path, data)

            return True

        except ID3NoHeaderError, err:
            read_failed = True

        except UnicodeEncodeError, err:
            read_failed = True

        except UnicodeDecodeError, err:
            read_failed = True

        except FLACNoHeaderError, err:
            read_failed = True

        except FLACVorbisError, err:
            read_failed = True

        except APENoHeaderError, err:
            read_failed = True

        except OggVorbisHeaderError, err:
            read_failed = True

        except MP4MetadataError, err:
            read_failed = True

        except MP4MetadataValueError, err:
            read_failed = True

        except MP4StreamInfoError, err:
            read_failed = True

        except MutagenError, err:
            ERR.error(err.__class__.__name__, exc_info=True)
            if isinstance(err.args[0], IOError):
                fs_avail = False
                while fs_avail is False:
                    ops.check_status()
                    print "file system offline, retrying in 5 seconds..." 
                    time.sleep(5)
                    fs_avail = os.access(path, os.R_OK) 

                print "resuming..." 
                self.read_tags(path, data)
                return True

        except Exception, err:
            ERR.error(err.message, exc_info=True)
            read_failed = True

        finally:
            ops.record_op_complete(const.READ, self.name, path, op_failed=read_failed)


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
        mp4_data = {}
        document = MP4(path)
        for item in document.items():
            if len(item) < 2: 
                continue

            key = util.uu_str(item[0])

            if '.' in key: 
                continue
            
            known = filehandler.get_known_fields('m4a')
            if key not in known:
                filehandler.add_field('m4a', key)

            if isinstance(item[1], bool):
                value = item[1]
            elif isinstance(item[1],(list, tuple)):
                if isinstance(item[1][0], basestring):
                    value = util.uu_str(item[1][0])
                else:
                    value = item[1][0]


            if isinstance(value, unicode) and len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_field(path, key, value)
                continue

            mp4_data[key] = util.uu_str(value)

        if len(mp4_data) > 0:
            mp4_data['_document_format'] = 'm4a'
            mp4_data['_reader'] = self.name
            mp4_data['_read_date'] = datetime.datetime.now().isoformat()
            data['attributes'].append(mp4_data)


class MutagenOggFlac(Pathogen):
    def __init__(self):
        super(MutagenOggFlac, self).__init__('mutagen-oggflac')


class MutagenAPEv2(Pathogen):
    def __init__(self):
        super(MutagenAPEv2, self).__init__('mutagen-apev2')

    def read_tags(self, path, data):
        ape_data = {}
        document = APEv2(path)
        for item in document.items():
            if len(item) < 2: continue

            key = util.uu_str(item[0])
            if key not in filehandler.get_known_fields('apev2'):
                try:
                    filehandler.add_field('apev2', key)
                except Exception, err:
                    continue
                    
            value = util.uu_str(item[1].value)
            if len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_field(path, key, value)
                continue

            ape_data[key] = value

        if len(ape_data) > 0:
            ape_data['_document_format'] = 'apev2'
            ape_data['_reader'] = self.name
            ape_data['_read_date'] = datetime.datetime.now().isoformat()
            data['attributes'].append(ape_data)


class MutagenFLAC(Pathogen):
    def __init__(self):
        super(MutagenFLAC, self).__init__('mutagen-flac')

    def read_tags(self, path, data):
        flac_data = {}
        document = FLAC(path)
        for tag in document.tags:
            if len(tag) < 2: continue
            known = filehandler.get_known_fields('flac')
            
            key = tag[0]  #util.uu_str(tag[0])
            if key not in known:
                filehandler.add_field('flac', key)
                
            value = util.uu_str(tag[1])
            if len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_field(path, key, value)
                continue
            flac_data[key] = value


        for tag in document.vc:
            key = util.uu_str(tag[0])
            if key not in filehandler.get_known_fields('flac'):
                filehandler.add_field('flac', key)

            value = util.uu_str(tag[1])
            if len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_field(path, key, value)
                continue

            if key not in flac_data:
                flac_data[key] = value

        if len(flac_data) > 0:
            flac_data['_document_format'] = 'flac'
            flac_data['_reader'] = self.name
            flac_data['_read_date'] = datetime.datetime.now().isoformat()
            data['attributes'].append(flac_data)


class MutagenID3(Pathogen):
    def __init__(self):
        super(MutagenID3, self).__init__('mutagen-id3')

    def read_tags(self, path, data):
        document = ID3(path)
        version = '.'.join([str(value) for value in document.version])
        document_format = 'ID3v%s' % version

        metadata = document.pprint() # gets all metadata
        tags = [x.split('=',1) for x in metadata.split('\n')] # substring[0:] is redundant

        id3_data = {}
        for tag in tags:
            if len(tag) < 2: 
                continue

            key = util.uu_str(tag[0])
            if len(key) == 4 and key not in filehandler.get_known_fields(document_format) and key != "TXXX":
                try:
                    filehandler.add_field(document_format, key)
                except Exception, err:
                    continue

            value = util.uu_str(tag[1])
            if value is None:
                continue

            if len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_field(path, key, value)
                # LOG.info(value)
                continue
            
            if key == u"TXXX":
                if not key in id3_data:
                    # id3_data[key] = []   
                    id3_data[key] = {}   

                subtags = value.split('=')
                subkey = util.uu_str(subtags[0].replace(' ', '_'))#.upper()
                if '.' in subkey: 
                    continue
                
                txxkey = '.'.join([key, subkey])
                if txxkey not in filehandler.get_known_fields(document_format):
                    try:
                        filehandler.add_field(document_format, txxkey)
                    except Exception, err:
                        continue

                id3_data[key][subkey] = util.uu_str(subtags[1])

            else:
                # if key in filehandler.get_fields(document_format):
                id3_data[key] = util.uu_str(value)

        if len(id3_data) > 0:
            id3_data['_document_format'] = document_format
            id3_data['_reader'] = self.name
            id3_data['_read_date'] = datetime.datetime.now().isoformat()
            data['attributes'].append(id3_data)

class MutagenOggVorbis(Pathogen):
    def __init__(self):
        super(MutagenOggVorbis, self).__init__('mutagen-oggvorbis')

    def read_tags(self, path, data):
        ogg_data = {}
        document = OggVorbis(path)
        for tag in document.tags:
            if len(tag) < 2: continue

            key = util.uu_str(tag[0])
            if key not in filehandler.get_known_fields('ogg'):
                try:
                    filehandler.add_field('ogg', key)
                except Exception, err:
                    continue

            value = util.uu_str(tag[1])
            if len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_field(path, key, value)
                continue

            ogg_data[key] = value

        if len(ogg_data) > 0:
            ogg_data['_document_format'] = 'ogg'
            ogg_data['_reader'] = self.name
            ogg_data['_read_date'] = datetime.datetime.now().isoformat()
            data['attributes'].append(ogg_data)


