import os, sys, datetime

import config, library
    
class Directive:

    def __init__(self, name, extensions=None, locations=None, requirements=None, frequency=None):
        self.name = name 
        self.extensions = extension if extensions != None else []
        self.locations = locations if locations != None else []
        self.requirements = requirements if requirements != None else []
        self.frequency = frequency
        self.last_applied = None

    def add_requirement(self, description, condition, approach, objective=None, resolution=None):
            self.requirements.append({ 'condition': condition, 'description': description, 
                'objective': objective, 'resolution': resolution, 'approach': approach })

    def applies(self, target):
        if self.frequency != None:
            if self.last_applied == None:
                self.applied = datetime.datetime.now()
            #TODO: else compare now to self_applied and respond false if time too short

        for requirement in self.requirements:
            if requirement['condition'] is target:
                return True

        for requirement in self.requirements:
            if requirement['condition'] is not None and requirement['condition'](target):
                return True

        return True
        
    def apply(self, target):
        for requirement in self.requirements:
            if requirement['condition'] is not None and requirement['condition'](target):
                if requirement['approach'] is not None: requirement['approach'](target)
                if requirement['objective'] is not None: requirement['objective'](target)
                if requirement['resolution'] is not None: requirement['resolution'](target)

    def read_config(self):
        # should directives have access to these files?
        # self.locations.append(config.NOSCAN)
        # self.locations.append(config.EXPUNGED)     
        for location in config.locations:
            # breaks the work into manageable chunks, conserve memory, but misses some files and waste a little time as well
            if location.endswith("albums") or location.endswith("compilations"):
                for genre in config.genre_folders:
                    self.locations.append(os.path.join(location, genre))
            
            # possibly taxing full evaluation, but hopefully the above has piece-mealed most of the work already
            self.locations.append(location)            

        self.locations.append([location for location in config.locations_ext])            
        self.locations.sort()    

# a nature is a configured list of directives, a server-level mode
class Nature:
    pass

def create(paths=None):
    directive = Directive(['mp3']) # library.get_active_media_formats() 
    # if len(paths) == 1 and paths[0] == config.START_FOLDER ?
    if paths == None: directive.read_config() 
    else: 
        for directory in paths: 
            directive.locations.append(directory)
        
    return directive