clear
rm $M2/python/mildred/db/generated/*.p*

echo 'updating mildred'
mysql mildred  < $M2/db/design/mildred.sql
echo 'updating mildred action'
mysql mildred_action < $M2/db/design/action.sql
echo 'updating mildred introspection'
mysql mildred_introspection < $M2/db/design/ssintrospection.sql
echo 'updating scratch'
mysql scratch < $M2/db/scratch.sql

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

