clear
echo "creating databases..."
mysql sys < $M2/db/setup/setup.sql

echo "creating media schema..."
mysql media < $M2/db/setup/setup-media.sql
echo "creating mildred schema..."
mysql mildred < $M2/db/setup/setup-mildred.sql
echo "creating mildred action schema..."
mysql mildred_action < $M2/db/setup/setup-mildred_action.sql
echo "creating mildred admin schema..."
mysql mildred_admin < $M2/db/setup/setup-mildred_admin.sql
echo "creating mildred introspection schema..."
mysql mildred_introspection < $M2/db/setup/setup-mildred_introspection.sql
# echo "creating scratch schema..."
# mysql scratch < $M2/db/setup/setup-scratch.sql

echo "restoring data to mildred schema..."
mysql mildred < $M2/db/bak/dump/backup-mildred.sql
echo "restoring data to mildred introspection schema..."
mysql mildred_introspection < $M2/db/bak/dump/backup-mildred_introspection.sql

echo "updating mildred schema..."
mysql mildred < $M2/db/design/mildred.sql
echo "updating mildred action schema..."
mysql mildred_action < $M2/db/design/action.sql
echo "updating mildred inrospection schema..."
mysql mildred_introspection < $M2/design/introspection.sql
echo "updating scratch schema..."
mysql scratch < $M2/db/design/scratch.sql


####

touch $M2/python/mildred/db/__init__.py
touch $M2/python/mildred/db/generated/__init__.py
sqlacodegen mysql://root:steel@localhost/media > $M2/python/mildred/db/generated/sqla_media.py
cat $M2/python/mildred/db/generated/sqla_media.py
sqlacodegen mysql://root:steel@localhost/mildred > $M2/python/mildred/db/generated/sqla_mildred.py
cat $M2/python/mildred/db/generated/sqla_mildred.py
sqlacodegen mysql://root:steel@localhost/mildred_action > $M2/python/mildred/db/generated/sqla_action.py
cat $M2/python/mildred/db/generated/sqla_action.py
sqlacodegen mysql://root:steel@localhost/mildred_admin > $M2/python/mildred/db/generated/sqla_admin.py
cat $M2/python/mildred/db/generated/sqla_admin.py
sqlacodegen mysql://root:steel@localhost/mildred_introspection > $M2/python/mildred/db/generated/sqla_introspection.py
cat $M2/python/mildred/db/generated/sqla_introspection.py
sqlacodegen mysql://root:steel@localhost/scratch > $M2/python/mildred/db/generated/sqla_scratch.py
cat $M2/python/mildred/db/generated/sqla_scratch.py
