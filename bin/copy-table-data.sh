#!/usr/bin/env bash
echo "dumping $1 $2 to $M2/bak/db/$1-$2.sql..."
mysqldump --complete-insert --extended-insert --skip-opt --skip-dump-date --add-drop-table $1 $2  > $M2/db/bak/$1-$2.sql
