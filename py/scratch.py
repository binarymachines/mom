import sys, os

import sql

def main():

    print sql.load_query('cache_cache_matches', 'Bobby "Blue" Bland', "Morton's Treehouse")


if __name__ == '__main__':
    main()