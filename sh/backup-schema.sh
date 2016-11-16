#!/usr/bin/env bash
echo "dumping $1 schema to $2..."
mysqldump --skip-dump-date  $1 > $2