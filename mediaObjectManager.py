done = True
#!/usr/bin/python

import os
from mutagen.id3 import ID3, ID3NoHeaderError

class ScanCriteria:
    def __init__(self):
        self.locations = []
        self.extensions = ['mp3']
#    def __init__(self, scan_locations, scan_extensions):
#        self.locations = scan_locations
#        self.extensions = scan_extensions

class MediaObjectManager:
    def __init__(self):
        self._x = None

    def scan(self, criteria):

        results = []

        for loc in criteria.locations:
            print("\n" + loc + "\n")
            for root, dirs, files in os.walk(loc, topdown=True, followlinks=False):
                for filename in files:
                    for ext in criteria.extensions:
                        if filename.endswith(''.join(['.', ext])):
                            self.handle_file(loc, root, filename)

    def handle_file(self, location, root, filename):
        print(os.path.join(root, filename))

        try:
            mediafile = ID3(os.path.join(root, filename))
            metadata = mediafile.pprint() # gets all metadata
            tags = [x.split('=',1) for x in metadata[0:].split('\n')]
            for tag in tags:
                newtag = []
                for field in tag:
                    newtag.append(str(field))
                print (newtag)
            print('\n')
        except ID3NoHeaderError:
            print("NO ID3 HEADER")


s = ScanCriteria()
s.locations.append("/media/removable/Audio/music/recently downloaded albums")
#s.locations.append("/media/removable/Audio/music/recently downloaded compilations")
s.locations.append("/media/removable/SEAGATE 932/Media/Music/mp3")
#s.extensions = ["flac"]

m = MediaObjectManager()
m.scan(s)
