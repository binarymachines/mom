"""housekeeping mode"""

def clean(context):
    pass

# deal with duplicate records in mysql
# deal with duplicate records in elasticsearch

# select from document, order by absolute path
# use hex version of absolute path to check es for dupllicates
# add esids of found dupes to temp table
# delete least recent es_docs based on file_reader dates

# select distinct absolute paths into temp table
# compare total count

# or

# copy rows one by one into indexed table and delete rows that generate exceptions

# clear HLSCAN ops for directories that aren't in primary path context or immediate sub-directories
# RULE: if the path contains media, it was not an HLSCAN, it was a SCAN

