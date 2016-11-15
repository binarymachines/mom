#!/usr/bin/env bash
pushd $m2

clear

echo '----------------------------'
echo 'Backing up Mildred Databases'
echo '----------------------------'
echo

echo "removing existing backups..."
rm bak/sql/*.sql
rm bak/sql/dump/*.sql
rm setup/sql/*.sql

echo "dumping schemas..."

./backup-schema.sh mildred bak/sql/dump/backup-mildred.sql
./backup-schema.sh mildred_admin bak/sql/dump/backup-mildred_admin.sql
./backup-schema.sh mildred_introspection bak/sql/dump/backup-mildred_introspection.sql
./backup-schema.sh media bak/sql/dump/backup-media.sql
./backup-schema.sh scratch bak/sql/dump/backup-scratch.sql

echo "copying lookup tables..."

./copy-table-data.sh mildred directory
./copy-table-data.sh mildred directory_amelioration
./copy-table-data.sh mildred directory_attribute
./copy-table-data.sh mildred directory_constant

./copy-table-data.sh mildred document_category
./copy-table-data.sh mildred document_format
./copy-table-data.sh mildred document_metadata
./copy-table-data.sh mildred document_type

./copy-table-data.sh mildred match_discount
./copy-table-data.sh mildred match_weight
./copy-table-data.sh mildred matcher
./copy-table-data.sh mildred matcher_field

./copy-table-data.sh mildred_admin org
./copy-table-data.sh mildred_admin member

./copy-table-data.sh mildred_introspection mode
./copy-table-data.sh mildred_introspection state
./copy-table-data.sh mildred_introspection mode_state_default
./copy-table-data.sh mildred_introspection mode_state_default_param
./copy-table-data.sh mildred_introspection error
./copy-table-data.sh mildred_introspection error_attribute

./copy-table-data.sh media artist_alias
./copy-table-data.sh media artist_amelioration

echo "adding lookup tables to git."
git add bak/sql/*.sql

# mysqldump --routines scratch > bak/sql/scratch.sql

echo "copying setup tables..."
./copy-table-ddl.sh mildred setup/sql/setup-mildred.sql
./copy-table-ddl.sh mildred_admin setup/sql/setup-mildred_admin.sql
./copy-table-ddl.sh mildred_introspection setup/sql/setup-mildred_introspection.sql
./copy-table-ddl.sh media setup/sql/setup-media.sql
./copy-table-ddl.sh scratch setup/sql/backup-media-no-data.sql

echo "adding setup tables to git."
git add setup/sql/*.sql

echo '----------------------------'
echo 'Database backup is complete!'
echo '----------------------------'
echo
git status
git commit -m 'db snapshot'

# git push

popd