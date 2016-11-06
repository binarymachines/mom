pushd $m2

rm bak/sql/*.sql

mysqldump mildred > $m2/bak/sql/backup-mildred.sql
mysqldump mildred_admin > $m2/bak/sql/backup-mildred_admin.sql
mysqldump mildred_introspection > $m2/bak/sql/backup-mildred_introspection.sql
mysqldump media > $m2/bak/sql/backup-media.sql

mysqldump scratch > $m2/bak/sql/scratch.sql

./copy-table-data.sh mildred directory
./copy-table-data.sh mildred directory_amelioration
./copy-table-data.sh mildred directory_attribute
./copy-table-data.sh mildred directory_constant

./copy-table-data.sh mildred document_category
./copy-table-data.sh mildred document_format
./copy-table-data.sh mildred document_metadata
./copy-table-data.sh mildred document_type

./copy-table-data.sh mildred match_discount
./copy-table-data.sh mildred match_weight
./copy-table-data.sh mildred matcher
./copy-table-data.sh mildred matcher_field

./copy-table-data.sh media artist_alias
./copy-table-data.sh media artist_amelioration

rm setup/sql/*.sql

mysqldump --no-data mildred > $m2/setup/sql/setup-mildred.sql
mysqldump --no-data mildred_admin > $m2/setup/sql/setup-mildred_admin.sql
mysqldump --no-data mildred_introspection > $m2/setup/sql/setup-mildred_introspection.sql
mysqldump --no-data media > $m2/setup/sql/setup-media.sql

popd