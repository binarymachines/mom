#!/usr/bin/env bash
pushd $M2

clear

echo '----------------------------'
echo 'Backing up Mildred Databases'
echo '----------------------------'
echo

echo "removing existing backups..."
rm bak/db/*.sql
rm bak/db/dump/*.sql
rm setup/db/*.sql

echo "copying lookup tables..."

./bin/copy-table-data.sh mildred directory
./bin/copy-table-data.sh mildred directory_amelioration
./bin/copy-table-data.sh mildred directory_attribute
./bin/copy-table-data.sh mildred directory_constant

./bin/copy-table-data.sh mildred document_category
./bin/copy-table-data.sh mildred document_metadata

./bin/copy-table-data.sh mildred file_format
./bin/copy-table-data.sh mildred file_type

./bin/copy-table-data.sh mildred match_discount
./bin/copy-table-data.sh mildred match_weight
./bin/copy-table-data.sh mildred matcher
./bin/copy-table-data.sh mildred matcher_field

./bin/copy-table-data.sh mildred_admin org
./bin/copy-table-data.sh mildred_admin member

./bin/copy-table-data.sh mildred_introspection mode
./bin/copy-table-data.sh mildred_introspection state
./bin/copy-table-data.sh mildred_introspection mode_state_default
./bin/copy-table-data.sh mildred_introspection mode_state_default_param
#./bin/copy-table-data.sh mildred_introspection error
#./bin/copy-table-data.sh mildred_introspection error_attribute

./bin/copy-table-data.sh media artist_alias
./bin/copy-table-data.sh media artist_amelioration

echo "adding lookup tables to git."
git add bak/db/*.sql

mysqldump --routines scratch > bak/db/scratch.sql

echo "copying setup tables..."
./bin/copy-table-ddl.sh mildred setup/db/setup-mildred.sql
./bin/copy-table-ddl.sh mildred_admin setup/db/setup-mildred_admin.sql
./bin/copy-table-ddl.sh mildred_action setup/db/setup-mildred_action.sql
./bin/copy-table-ddl.sh mildred_introspection setup/db/setup-mildred_introspection.sql
./bin/copy-table-ddl.sh media setup/db/setup-media.sql
./bin/copy-table-ddl.sh scratch setup/db/backup-media-no-data.sql

echo "adding setup tables to git."
git add setup/db/*.sql

echo "dumping schemas..."

./bin/backup-schema.sh mildred
./bin/backup-schema.sh mildred_admin
./bin/backup-schema.sh mildred_action
./bin/backup-schema.sh mildred_introspection
./bin/backup-schema.sh media
./bin/backup-schema.sh scratch

echo '----------------------------'
echo 'Database backup is complete!'
echo '----------------------------'
echo

git status
git commit -m 'db snapshot'
git push

popd