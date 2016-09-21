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

def main():
    print sql.get_query('cache_cache_matches', 'Bobby "Blue" Bland', "Morton's Treehouse")


if __name__ == '__main__':
    main()