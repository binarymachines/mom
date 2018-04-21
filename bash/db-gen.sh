#!/usr/bin/env bash
pushd $MILDRED_HOME

clear

echo '----------------------------'
echo 'Backing up Mildred Databases'
echo '----------------------------'
echo

# mysqldump admin > $MILDRED_HOME/db/design/admin.sql --add-drop-table --complete-insert --add-drop-database
mysqldump analysis > $MILDRED_HOME/db/design/analysis.sql --add-drop-table --complete-insert --add-drop-database
mysqldump elastic > $MILDRED_HOME/db/design/elastic.sql --add-drop-table --complete-insert --add-drop-database
mysqldump media > $MILDRED_HOME/db/design/media.sql --add-drop-table --complete-insert --add-drop-database
mysqldump service > $MILDRED_HOME/db/design/service.sql --add-drop-table --complete-insert --add-drop-database
mysqldump suggestion > $MILDRED_HOME/db/design/suggestion.sql --add-drop-table --complete-insert --add-drop-database
mysqldump scratch > $MILDRED_HOME/db/design/scratch.sql --add-drop-table --complete-insert --add-drop-database


echo '----------------------------'
echo 'Database backup is complete!'
echo '----------------------------'
echo

# git status
# git commit -m 'db snapshot'
# git push

popd