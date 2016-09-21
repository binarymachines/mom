import os, sys, datetime
   
class Directive:

    def __init__(self, name, requirements=None, frequency=None):
        self.name = name 
        self.requirements = requirements if requirements is not None else []
        self.frequency = frequency
        self.last_applied = None
        self.priority = 100

    # condition = problem path, approach = add work item, objective = fix path op, resolution = do approved work item       
    def add_requirement(self, description, condition, approach, objective=None, resolution=None):
            self.requirements.append({ 'condition': condition, 'description': description, 
                'objective': objective, 'resolution': resolution, 'approach': approach })

    def applies(self, target):
        if self.frequency is not None:
            if self.last_applied is None:
                self.applied = datetime.datetime.now()
            #TODO: else compare now to self_applied and respond false if time too short

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


# a nature is a configured list of directives, a service-level mode
class Nature:
    def __init__(self):
        directives = []

