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

./bash/copy-table-data.sh media directory
./bash/copy-table-data.sh media directory_amelioration
./bash/copy-table-data.sh media directory_attribute
./bash/copy-table-data.sh media directory_constant

./bash/copy-table-data.sh media category
./bash/copy-table-data.sh media file_attribute

./bash/copy-table-data.sh media file_format
./bash/copy-table-data.sh media file_type

./bash/copy-table-data.sh media match_discount
./bash/copy-table-data.sh media match_weight
./bash/copy-table-data.sh media matcher
./bash/copy-table-data.sh media matcher_field

./bash/copy-table-data.sh admin org
./bash/copy-table-data.sh admin member

./bash/copy-table-data.sh service mode
./bash/copy-table-data.sh service state
./bash/copy-table-data.sh service mode_state_default
./bash/copy-table-data.sh service mode_state_default_param
#./bash/copy-table-data.sh service error
#./bash/copy-table-data.sh service error_attribute

./bash/copy-table-data.sh media artist_alias
./bash/copy-table-data.sh media artist_amelioration

echo "adding lookup tables to git."
git add db/bak/*.sql

# mysqldump --routines scratch > db/bak/scratch.sql

echo "copying setup tables..."
./bash/copy-table-ddl.sh media db/setup/setup-media.sql
./bash/copy-table-ddl.sh admin db/setup/setup-admin.sql
./bash/copy-table-ddl.sh analysis db/setup/setup-analysis.sql
./bash/copy-table-ddl.sh service db/setup/setup-service.sql
./bash/copy-table-ddl.sh media db/setup/setup-media.sql
./bash/copy-table-ddl.sh scratch db/setup/backup-media-no-data.sql

echo "adding setup tables to git."
git add db/setup/*.sql

echo "dumping schemas..."

./bash/backup-schema.sh media
./bash/backup-schema.sh admin
./bash/backup-schema.sh analysis
./bash/backup-schema.sh service
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