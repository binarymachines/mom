#! /usr/bin/python

import os, sys, pprint, json

import config, constants, mySQL4es

pp = pprint.PrettyPrinter(indent=4)

def build_match_docs():

    q = """SELECT id, absolute_path FROM es_document 
            WHERE index_name = '%s' and doc_type = 'media_folder' 
              and absolute_path like '%sword up%s' limit 10""" % (constants.ES_INDEX_NAME, '%', '%')

    folders = mySQL4es.run_query(q)
    for folder in folders:
        folder_id = folder[0]
        folder_path = folder[1]
        
        files = []
        folder_data = {}
        folder_data["search_path"] = folder_path
        folder_data["search_path_id"] = folder_id
        folder_data["files"] = []

        matches_exist = False

        q = """SELECT es.id, es.absolute_path FROM es_document es 
                WHERE index_name = '%s' 
                  and es.absolute_path LIKE "%s%s" 
                  and es.id IN (SELECT media_doc_id FROM matched)""" % (constants.ES_INDEX_NAME, folder_path, '%')
                  
        mediafiles = mySQL4es.run_query(q)
        for media in mediafiles:
            # TODO: add tag data from elasticsearch to this record 
            parentfolder = os.path.abspath(os.path.join(media[1], os.pardir))
            file_data = { 'file_id': media[0], 'file_path': parentfolder, 'file_name': media[1].split('/')[-1] }

            parent_data = {}
            match_list = []
            matcher_data = {}
            match_folder_data = {}

            q = """SELECT DISTINCT m.matcher_name, m.match_score, m.match_doc_id, es.absolute_path, m.id  
                     FROM matched m, es_document es 
                    WHERE es.index_name = '%s' and es.id = m.match_doc_id and m.media_doc_id = '%s'
                   ORDER BY m.matcher_name, es.absolute_path""" % (constants.ES_INDEX_NAME, media[0])
            
            matches = mySQL4es.run_query(q)
            for match in matches:
                matches_exist = True 
                matchername = match[0]
                matchscore = match[1]
                matchfileid = match[2]
                matchpath = match[3]
                matchid = match[4]
                matchfile = matchpath.split('/')[-1]
                parentfolder = os.path.abspath(os.path.join(matchpath, os.pardir))

                match_data = { 'match_id': matchid, 'matcher': matchername, 'match_score': matchscore, 'match_file_id': matchfileid, 'match_file': matchfile }

                if not parentfolder in parent_data:
                    parent_data[parentfolder] = {'match_folder': parentfolder }
                    parent_data[parentfolder]['matching_files'] = []

                parent_data[parentfolder]['matching_files'].append(match_data)

            for folder in parent_data:
                match_list.append(parent_data[folder])

            # add matches to file data
            file_data["matches"] = match_list
            
            # add file data to file list
            files.append(file_data)

        # add file list to folder data
        folder_data["files"] = files

        # result = json.dumps(folder_data)
        if matches_exist:
            pp.pprint(folder_data)
        

def main():
    # print 'running finder'
    config.configure()
    build_match_docs() 

    folder = {'folder': '/slash/slash/slash/somefolder'}

    # files = []
    # files.append({'file': 'some file.exe', 'attribute': 'exe attrib'})
    # files.append({'file': 'some other file.txt', 'attribute': 'text attrib'})
    # files.append({'file': 'yet another file.jpg', 'attribute': 'pic attrib'})

    # folder['files'] = files

    # pp.pprint(folder)

# main
if __name__ == '__main__':
    main()