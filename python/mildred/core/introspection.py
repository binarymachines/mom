# cumulative errors
# cause of defect
# rate of decay

# persistence of mode state allow modes to be restored and replayed, allowing analysis of transitions between mode state snapshots, which describe traverals

# The mildred exception hierarchy persists metrics across sessions, which will be implemented by Selector2 the presenter of this alternative to the switch api
# at the lower implementation level, decorators using the transitionhandler pattern are added to ensure error reception and report

# transition of mode from one state to another is determined by adminstrators of state

# insight recognizes changes at the level of introspection

# in a process, a mode has an associated state context

# modes express conditional polymorphism by applying the condition associated with its state when asked by selector

import logging

from pydoc import locate

import log

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)


def get_func(qname):
    return locate(qname)


def get_qualified_name(*nameparts):
    result = []
    for part in nameparts:
        if part:
            result.append(part)

    return '.'.join(result)


    #
