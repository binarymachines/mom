clear
# echo "creating databases..."
# echo "create schema media" | mysql
# echo "create schema mildred" | mysql
# echo "create schema mildred_action" | mysql
# echo "create schema mildred_admin" | mysql
# echo "create schema mildred_introspection" | mysql
# echo "create schema scratch" | mysql

# echo "creating media schema..."
# mysql media < $MILDRED_HOME/db/setup/setup-media.sql
# echo "creating mildred schema..."
# mysql mildred < $MILDRED_HOME/db/setup/setup-mildred.sql
# echo "creating mildred action schema..."
# mysql mildred_action < $MILDRED_HOME/db/setup/setup-mildred_action.sql
# echo "creating mildred admin schema..."
# mysql mildred_admin < $MILDRED_HOME/db/setup/setup-mildred_admin.sql
# echo "creating mildred introspection schema..."
# mysql mildred_introspection < $MILDRED_HOME/db/setup/setup-mildred_introspection.sql
# # echo "creating scratch schema..."
# # mysql scratch < $MILDRED_HOME/db/setup/setup-scratch.sql

# echo "restoring data to mildred schema..."
# mysql mildred < $MILDRED_HOME/db/bak/dump/backup-mildred.sql
# echo "restoring data to mildred introspection schema..."
# mysql mildred_introspection < $MILDRED_HOME/db/bak/dump/backup-mildred_introspection.sql

echo "updating mildred schema..."
mysql mildred < $MILDRED_HOME/db/design/mildred.sql
echo "updating mildred action schema..."
mysql mildred_action < $MILDRED_HOME/db/design/action.sql
echo "updating mildred inrospection schema..."
mysql mildred_introspection < $MILDRED_HOME/design/introspection.sql
echo "updating scratch schema..."
mysql scratch < $MILDRED_HOME/db/design/scratch.sql


####

touch $MILDRED_HOME/python/mildred/db/__init__.py
touch $MILDRED_HOME/python/mildred/db/generated/__init__.py
sqlacodegen mysql://root:steel@localhost/media > $MILDRED_HOME/python/mildred/db/generated/sqla_media.py
sqlacodegen mysql://root:steel@localhost/mildred > $MILDRED_HOME/python/mildred/db/generated/sqla_mildred.py
sqlacodegen mysql://root:steel@localhost/mildred_action --tables action_dispatch,action,action_param,meta_action,meta_action_param,reason,reason_param,meta_reason,meta_reason_param,action_reason,m_action_m_reason > $MILDRED_HOME/python/mildred/db/generated/sqla_action.py
sqlacodegen mysql://root:steel@localhost/mildred_admin > $MILDRED_HOME/python/mildred/db/generated/sqla_admin.py
sqlacodegen mysql://root:steel@localhost/mildred_introspection > $MILDRED_HOME/python/mildred/db/generated/sqla_introspection.py
sqlacodegen mysql://root:steel@localhost/scratch > $MILDRED_HOME/python/mildred/db/generated/sqla_scratch.py

