#!/usr/bin/env bash
pushd $MILDRED_HOME

clear

echo '----------------------------'
echo 'Backing up Mildred Databases'
echo '----------------------------'
echo

echo "removing existing backups..."
rm db/bak/*.sql
rm db/bak/dump/*.sql
rm db/setup/*.sql

echo "copying tables..."

./bash/copy-table-data.sh mildred directory
./bash/copy-table-data.sh mildred directory_amelioration
./bash/copy-table-data.sh mildred directory_attribute
./bash/copy-table-data.sh mildred directory_constant

./bash/copy-table-data.sh mildred document_category
./bash/copy-table-data.sh mildred document_attribute

./bash/copy-table-data.sh mildred file_format
./bash/copy-table-data.sh mildred file_type

./bash/copy-table-data.sh mildred match_discount
./bash/copy-table-data.sh mildred match_weight
./bash/copy-table-data.sh mildred matcher
./bash/copy-table-data.sh mildred matcher_field

./bash/copy-table-data.sh mildred_admin org
./bash/copy-table-data.sh mildred_admin member

./bash/copy-table-data.sh mildred_introspection mode
./bash/copy-table-data.sh mildred_introspection state
./bash/copy-table-data.sh mildred_introspection mode_state_default
./bash/copy-table-data.sh mildred_introspection mode_state_default_param
#./bash/copy-table-data.sh mildred_introspection error
#./bash/copy-table-data.sh mildred_introspection error_attribute

./bash/copy-table-data.sh media artist_alias
./bash/copy-table-data.sh media artist_amelioration

echo "adding lookup tables to git."
git add db/bak/*.sql

# mysqldump --routines scratch > db/bak/scratch.sql

echo "copying setup tables..."
./bash/copy-table-ddl.sh mildred db/setup/setup-mildred.sql
./bash/copy-table-ddl.sh mildred_admin db/setup/setup-mildred_admin.sql
./bash/copy-table-ddl.sh mildred_action db/setup/setup-mildred_action.sql
./bash/copy-table-ddl.sh mildred_introspection db/setup/setup-mildred_introspection.sql
./bash/copy-table-ddl.sh media db/setup/setup-media.sql
./bash/copy-table-ddl.sh scratch db/setup/backup-media-no-data.sql

echo "adding setup tables to git."
git add db/setup/*.sql

echo "dumping schemas..."

./bash/backup-schema.sh mildred
./bash/backup-schema.sh mildred_admin
./bash/backup-schema.sh mildred_action
./bash/backup-schema.sh mildred_introspection
./bash/backup-schema.sh media
./bash/backup-schema.sh scratch

echo '----------------------------'
echo 'Database backup is complete!'
echo '----------------------------'
echo

git status
git commit -m 'db snapshot'
git push

popd