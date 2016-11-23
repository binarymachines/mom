"""pathogen is a wrapper around the mutagen API"""

import os, json, sys, logging, traceback, time, datetime

from mutagen import MutagenError
from mutagen.id3 import ID3, ID3NoHeaderError
from mutagen.flac import FLAC, FLACNoHeaderError, FLACVorbisError
from mutagen.apev2 import APEv2, APENoHeaderError, APEUnsupportedVersionError
from mutagen.oggvorbis import OggVorbis, OggVorbisHeaderError
from mutagen.mp4 import MP4, MP4MetadataError, MP4MetadataValueError, MP4StreamInfoError

import const
import ops
import filehandler
from filehandler import FileHandler
from const import MAX_DATA_LENGTH
from core import log
from core.errors import BaseClassException


LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)


class Mutagen(FileHandler):
    def __init__(self, name, *extensions):
        super(Mutagen, self).__init__(name, *extensions)


    def handle_file(self, asset, data):
        LOG.info("%s reading file: %s" % (self.name, asset.absolute_path))

        read_failed = False

        try:
            ops.record_op_begin(const.READ, self.name, asset.absolute_path, asset.esid)
            self.read_tags(asset, data)
            return True

        except ID3NoHeaderError, err:
            read_failed = True
            if asset.absolute_path.lower().endswith('mp3'):
                self.handle_exception(err, asset, data)

        except UnicodeEncodeError, err:
            read_failed = True
            self.handle_exception(err, asset, data)

        except UnicodeDecodeError, err:
            read_failed = True
            self.handle_exception(err, asset, data)

        except FLACNoHeaderError, err:
            read_failed = True
            self.handle_exception(err, asset, data)

        except FLACVorbisError, err:
            read_failed = True
            self.handle_exception(err, asset, data)

        except APENoHeaderError, err:
            read_failed = True
            self.handle_exception(err, asset, data)

        except OggVorbisHeaderError, err:
            read_failed = True
            self.handle_exception(err, asset, data)

        except MP4MetadataError, err:
            read_failed = True
            self.handle_exception(err, asset, data)

        except MP4MetadataValueError, err:
            read_failed = True
            self.handle_exception(err, asset, data)

        except MP4StreamInfoError, err:
            read_failed = True
            self.handle_exception(err, asset, data)

        except MutagenError, err:
            ERR.error(err.__class__.__name__, exc_info=True)
            if isinstance(err.args[0], IOError):
                fs_avail = False
                while fs_avail is False:
                    ops.check_status()
                    print "file system offline, retrying in 5 seconds..." 
                    time.sleep(5)
                    fs_avail = os.access(asset.absolute_path, os.R_OK) 

                print "resuming..." 
                self.read_tags(asset, data)
                return True

        except Exception, err:
            ERR.error(err.message, exc_info=True)
            read_failed = True
            self.handle_exception(err, asset, data)

        finally:
            ops.record_op_complete(const.READ, self.name, asset.absolute_path, asset.esid, op_failed=read_failed)


    def read_tags(self, asset, data):
        raise BaseClassException(Mutagen)



class MutagenAAC(Mutagen):
    def __init__(self):
        super(MutagenAAC, self).__init__('mutagen-aac', 'aac')


class MutagenM4A(Mutagen):
    def __init__(self):
        super(MutagenM4A, self).__init__('mutagen-m4a', 'm4a')


class MutagenMP4(Mutagen):
    def __init__(self):
        super(MutagenMP4, self).__init__('mutagen-mp4', 'mp4', 'm4a')

    def read_tags(self, asset, data):
        mp4_data = {}
        document = MP4(asset.absolute_path)
        for item in document.items():
            if len(item) < 2: continue

            key = item[0]
            if key not in filehandler.get_known_fields('m4a'):
                filehandler.add_field('m4a', key)

            try:
                value = item[1][0]
            except Exception, err:
                value = item[1]

            if isinstance(value, basestring):
                if len(value) > MAX_DATA_LENGTH:
                    filehandler.report_invalid_field(asset.absolute_path, key, value)
                    continue

            mp4_data[key] = value

        if len(mp4_data) > 0:
            mp4_data['_reader'] = self.name
            mp4_data['_read_date'] = datetime.datetime.now().isoformat()
            data['properties'].append(mp4_data)


class MutagenOggFlac(Mutagen):
    def __init__(self):
        super(MutagenOggFlac, self).__init__('mutagen-oggflac', 'ogg', 'flac')

class MutagenAPEv2(Mutagen):
    def __init__(self):
        super(MutagenAPEv2, self).__init__('mutagen-apev2', 'ape', 'mpc')

    def read_tags(self, asset, data):
        ape_data = {}
        document = APEv2(asset.absolute_path)
        for item in document.items():
            if len(item) < 2: continue

            key = item[0]
            if key not in filehandler.get_known_fields('apev2'):
                filehandler.add_field('apev2', key)

            value = item[1].value
            if len(value) > MAX_DATA_LENGTH:
                filehandler.report_invalid_field(asset.absolute_path, key, value)
                continue

            ape_data[key] = value

        if len(ape_data) > 0:
            ape_data['_reader'] = self.name
            ape_data['_read_date'] = datetime.datetime.now().isoformat()
            data['properties'].append(ape_data)


class MutagenFLAC(Mutagen):
    def __init__(self):
        super(MutagenFLAC, self).__init__('mutagen-flac', 'flac')

    def read_tags(self, asset, data):
        flac_data = {}
        document = FLAC(asset.absolute_path)
        for tag in document.tags:
            if len(tag) < 2: continue
            
            key = tag[0]
            if key not in filehandler.get_known_fields('flac'):
                filehandler.add_field('flac', key)

            value = tag[1]
            if len(value) > MAX_DATA_LENGTH:
                filehandler.report_invalid_field(asset.absolute_path, key, value)
                continue
            flac_data[key] = value


        for tag in document.vc:
            key = tag[0]
            if key not in filehandler.get_known_fields('flac.vc'):
                filehandler.add_field('flac.vc', key)

            value = tag[1]
            if len(value) > MAX_DATA_LENGTH:
                filehandler.report_invalid_field(asset.absolute_path, key, value)
                continue

            flac_data[key] = value

        if len(flac_data) > 0:
            flac_data['_reader'] = self.name
            flac_data['_read_date'] = datetime.datetime.now().isoformat()
            data['properties'].append(flac_data)


class MutagenID3(Mutagen):
    def __init__(self):
        super(MutagenID3, self).__init__('mutagen-id3', 'mp3', 'flac')

    def read_tags(self, asset, data):
        document = ID3(asset.absolute_path)
        metadata = document.pprint() # gets all metadata
        tags = [x.split('=',1) for x in metadata.split('\n')] # substring[0:] is redundant

        id3_data = {}
        for tag in tags:
            if len(tag) < 2: continue

            key = tag[0]
            if len(key) == 4 and key not in filehandler.get_known_fields('ID3V2'):
                filehandler.add_field('ID3V2', key)

            value = tag[1]
            if len(value) > MAX_DATA_LENGTH:
                filehandler.report_invalid_field(asset.absolute_path, key, value)
                # print value
                continue
            
            if key in filehandler.get_fields('ID3V2'):
                id3_data[key] = value
                # TODO: remove for version 0.9.0
                data[key] = value

            if key == "TXXX":
                for sub_field in filehandler.get_fields('ID3V2.TXXX'):
                    if sub_field in value:
                        subtags = value.split('=')
                        subkey = subtags[0].replace(' ', '_').upper()
                        if subkey not in filehandler.get_known_fields('ID3V2.TXXX'):
                            filehandler.add_field('ID3V2.TXXX', key)

                        id3_data[subkey] = subtags[1]

        # for version 0.9.0
        if len(id3_data) > 0:
            id3_data['version'] = document.version
            id3_data['_reader'] = self.name
            id3_data['_read_date'] = datetime.datetime.now().isoformat()
            data['properties'].append(id3_data)


class MutagenOggVorbis(Mutagen):
    def __init__(self):
        super(MutagenOggVorbis, self).__init__('mutagen-oggvorbis', 'ogg', 'oga')

    def read_tags(self, asset, data):
        ogg_data = {}
        document = OggVorbis(asset.absolute_path)
        for tag in document.tags:
            if len(tag) < 2: continue

            key = tag[0]
            if key not in filehandler.get_known_fields('ogg'):
                filehandler.add_field('ogg', key)

            value = tag[1]
            if len(value) > MAX_DATA_LENGTH:
                filehandler.report_invalid_field(asset.absolute_path, key, value)
                continue

            ogg_data[key] = value

        if len(ogg_data) > 0:
            ogg_data['_reader'] = self.name
            ogg_data['_read_date'] = datetime.datetime.now().isoformat()
            data['properties'].append(ogg_data)


