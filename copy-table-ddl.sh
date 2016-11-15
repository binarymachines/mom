#!/usr/bin/env bash
echo "writing ddl for $1 to $2..."
# mysqldump --skip-dump-date --routines --no-data --add-drop-table $1 $2  > $m2/setup/sql/$1-$2.sql
mysqldump --no-data --skip-dump-date $1 > $2
