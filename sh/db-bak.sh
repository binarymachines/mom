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

./sh/backup-schema.sh mildred bak/sql/dump/backup-mildred.sql
./sh/backup-schema.sh mildred_admin bak/sql/dump/backup-mildred_admin.sql
./sh/backup-schema.sh mildred_introspection bak/sql/dump/backup-mildred_introspection.sql
./sh/backup-schema.sh media bak/sql/dump/backup-media.sql
./sh/backup-schema.sh scratch bak/sql/dump/backup-scratch.sql

echo "copying lookup tables..."

./sh/copy-table-data.sh mildred directory
./sh/copy-table-data.sh mildred directory_amelioration
./sh/copy-table-data.sh mildred directory_attribute
./sh/copy-table-data.sh mildred directory_constant

./sh/copy-table-data.sh mildred document_category
./sh/copy-table-data.sh mildred document_format
./sh/copy-table-data.sh mildred document_metadata
./sh/copy-table-data.sh mildred document_type

./sh/copy-table-data.sh mildred match_discount
./sh/copy-table-data.sh mildred match_weight
./sh/copy-table-data.sh mildred matcher
./sh/copy-table-data.sh mildred matcher_field

./sh/copy-table-data.sh mildred_admin org
./sh/copy-table-data.sh mildred_admin member

./sh/copy-table-data.sh mildred_introspection mode
./sh/copy-table-data.sh mildred_introspection state
./sh/copy-table-data.sh mildred_introspection mode_state_default
./sh/copy-table-data.sh mildred_introspection mode_state_default_param
./sh/copy-table-data.sh mildred_introspection error
./sh/copy-table-data.sh mildred_introspection error_attribute

./sh/copy-table-data.sh media artist_alias
./sh/copy-table-data.sh media artist_amelioration

echo "adding lookup tables to git."
git add bak/sql/*.sql

# mysqldump --routines scratch > bak/sql/scratch.sql

echo "copying setup tables..."
./sh/copy-table-ddl.sh mildred setup/sql/setup-mildred.sql
./sh/copy-table-ddl.sh mildred_admin setup/sql/setup-mildred_admin.sql
./sh/copy-table-ddl.sh mildred_introspection setup/sql/setup-mildred_introspection.sql
./sh/copy-table-ddl.sh media setup/sql/setup-media.sql
./sh/copy-table-ddl.sh scratch setup/sql/backup-media-no-data.sql

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