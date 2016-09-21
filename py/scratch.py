import sys, os

import sql

# doc = "The doc_name property."
# def fget(self):
#     return self._doc_name
# def fset(self, value):
#     self._doc_name = value
# def fdel(self):
#     del self._doc_name
# return locals()
# doc_name = property(**doc_name()))

def query(field_names, field_values):
    
    formatted_values = [sql.quote_if_string(value) for value in field_values]


def main():
    query(['id', 'first_name', 'last_name'], ['5', 'Mark', 'Pippins'])

if __name__ == '__main__':
    main()