import config

class Directive:
    def __init__(self):
        self.locations = []
        self.extensions = []

def create(paths):
    print 'Setting up directive...'
    directive = Directive()

    directive.extensions = ['mp3'] # util.get_active_media_formats() - should be in config
    if paths == None:
        for location in config.locations: 
            if location.endswith("albums") or location.endswith("compilations"):
                for genre in config.genre_folders:
                    directive.locations.append(os.path.join(location, genre))
            else:
                directive.locations.append(location)            

        for location in config.locations_ext:
            directive.locations.append(location)            
        # directive.locations.append(config.NOSCAN)
        # directive.locations.append(config.EXPUNGED)     
    else: 
        for directory in paths:
            directive.locations.append(directory)
    
    # if len(paths) == 1 and paths[0] == config.START_FOLDER:
        # pass

    directive.locations.sort()
    
    return directive