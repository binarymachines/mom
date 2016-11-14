#!/usr/bin/env bash
echo "dumping $1 $2..."
mysqldump --complete-insert --extended-insert --skip-opt --skip-dump-date $1 $2  > $m2/bak/sql/$1-$2.sql
