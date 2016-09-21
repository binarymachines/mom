import os, sys, traceback, logging

import sql

def class Record(object):
    def __init__(self, type, table, fields):
        self.table = table
        self.fields = fields
        self.values = {}

    def insert(self):
        values = []
        for field in self.fields:
            values.append(values[field])
        
        sql.insert_values(self.table_name, self.fields, values)

    def update(self, updated_fields=None):
        values = []
        if updated_fields is None:
            for field in self.fields:
                values.append(values[field])
            sql.update_values(self.table_name, self.fields, values)
        else:
            for field in updated_fields:
                    values.append(values[field])
                sql.update_values(self.table_name, updated_fields, values)

def class OperationRecord(Record):
    def __init__(self, table, fields):
        fields = ['pid', 'start_time', 'end_time', 'target_esid', 'target_path']
        super(OperationRecord, self).__init__(table, table.upper(), fields)

