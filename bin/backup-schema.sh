#!/usr/bin/env bash
echo "dumping $1 schema to bak/db/dump/backup-$1.sql..."
mysqldump --verbose --flush-logs --skip-dump-date $1 > $M2/bak/db/dump/backup-$1.sql