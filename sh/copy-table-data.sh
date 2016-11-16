#!/usr/bin/env bash
echo "dumping $1 $2 to $m2/bak/sql/$1-$2.sql..."
mysqldump --complete-insert --extended-insert --skip-opt --skip-dump-date --add-drop-table $1 $2  > $m2/bak/sql/$1-$2.sql
