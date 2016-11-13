echo "wrriting ddl for $1 $2..."
mysqldump --routines --no-data $1 $2  > $m2/setup/sql/$1-$2.sql
