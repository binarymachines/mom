#!/usr/bin/env bash
echo "dumping $1 schema to bak/sql/dump/backup-$1.sql..."
mysqldump --verbose --flush-logs --skip-dump-date $1 > $M2/bak/sql/dump/backup-$1.sql