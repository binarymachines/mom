import datetime


class Directive:

    def __init__(self, name, context, requirements=None, frequency=None):
        self.name = name
        self.context = context
        self.requirements = requirements if requirements is not None else []
        self.frequency = frequency
        self.last_applied = None
        self.priority = 100

    # condition = problem path, approach = add work item, objective = fix path op, resolution = do approved work item
    def add_requirement(self, description, condition, approach, objective=None, resolution=None):
            self.requirements.append({ 'condition': condition, 'description': description,
                'objective': objective, 'resolution': resolution, 'approach': approach })

    def applies(self, target):
        if self.frequency:
            if self.last_applied is None:
                self.applied = datetime.datetime.now()
            #TODO: else compare now to self_applied and respond false if time too short
            # days = 0 - config.op_life
            # start = datetime.date.today() + datetime.timedelta(days)

        for requirement in self.requirements:
            if requirement['condition'] and requirement['condition'](target):
                return True

        return True

    def apply(self, target):
        for requirement in self.requirements:
            if requirement['condition'] and requirement['condition'](target):
                if requirement['approach']: requirement['approach'](target)
                if requirement['objective']: requirement['objective'](target)
                if requirement['resolution']: requirement['resolution'](target)


# a nature is a configured list of directives, a service-level mode
class Nature:
    def __init__(self):
        directives = []

