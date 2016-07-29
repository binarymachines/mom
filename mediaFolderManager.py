#!/usr/bin/python

import os, json, pprint, sys, traceback
from elasticsearch import Elasticsearch

class MediaFolderManager:
    def __init__(self, elasticsearchinstance):
        self.es = elasticsearchinstance
        self.current_dir = None
        self.latest_error = None

    def record_error(self, error_message):
        self.latest_error = error_message

    def has_errors(self, foldername):
        return false

    def set_active_folder(self, foldername):
        if self.current_dir != foldername:
            self.current_dir = foldername
            self.latest_error = None
            print(self.current_dir)
