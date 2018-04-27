#!/usr/bin/env bash
pushd $MILDRED_HOME

clear

echo '----------------------------'
echo 'Backing up Mildred Databases'
echo '----------------------------'
echo

mysqldump admin > $MILDRED_HOME/db/design/admin.sql --add-drop-table --complete-insert --skip-dump-date
mysqldump analysis > $MILDRED_HOME/db/design/analysis.sql --add-drop-table --complete-insert --skip-dump-date
mysqldump elastic > $MILDRED_HOME/db/design/elastic.sql --add-drop-table --complete-insert --skip-dump-date
mysqldump media > $MILDRED_HOME/db/design/media.sql --add-drop-table --complete-insert --skip-dump-date
mysqldump service > $MILDRED_HOME/db/design/service.sql --add-drop-table --complete-insert --skip-dump-date
mysqldump suggestion > $MILDRED_HOME/db/design/suggestion.sql --add-drop-table --complete-insert --skip-dump-date
mysqldump scratch > $MILDRED_HOME/db/design/scratch.sql --add-drop-table --complete-insert --skip-dump-date

# mysqldump --routines --all-databases --add-drop-table --complete-insert > $MILDRED_HOME/db/design/all.sql
mysqldump --routines --databases admin analysis elastic media service suggestion scratch --add-drop-table --complete-insert > $MILDRED_HOME/db/design/all.sql


echo '----------------------------'
echo 'Database backup is complete!'
echo '----------------------------'
echo

# git status
# git commit -m 'db snapshot'
# git push

popd