clear
# echo "creating databases..."
# echo "create schema media" | mysql
# echo "create schema media" | mysql
# echo "create schema analysis" | mysql
# echo "create schema admin" | mysql
# echo "create schema service" | mysql
# echo "create schema scratch" | mysql

# echo "creating media schema..."
# mysql media < $MILDRED_HOME/db/setup/setup-media.sql
# echo "creating media schema..."
# mysql media < $MILDRED_HOME/db/setup/setup-media.sql
# echo "creating media action schema..."
# mysql analysis < $MILDRED_HOME/db/setup/setup-analysis.sql
# echo "creating media admin schema..."
# mysql admin < $MILDRED_HOME/db/setup/setup-admin.sql
# echo "creating media introspection schema..."
# mysql service < $MILDRED_HOME/db/setup/setup-service.sql
# # echo "creating scratch schema..."
# # mysql scratch < $MILDRED_HOME/db/setup/setup-scratch.sql

# echo "restoring data to media schema..."
# mysql media < $MILDRED_HOME/db/bak/dump/backup-media.sql
# echo "restoring data to media introspection schema..."
# mysql service < $MILDRED_HOME/db/bak/dump/backup-service.sql

echo "updating media schema..."
mysql media < $MILDRED_HOME/db/design/media.sql
echo "updating media action schema..."
mysql analysis < $MILDRED_HOME/db/design/analysis.sql
echo "updating media inrospection schema..."
mysql service < $MILDRED_HOME/design/service.sql
echo "updating scratch schema..."
mysql scratch < $MILDRED_HOME/db/design/scratch.sql


####

touch $MILDRED_HOME/python/server/db/__init__.py
touch $MILDRED_HOME/python/server/db/generated/__init__.py
sqlacodegen mysql://root:steel@localhost/media > $MILDRED_HOME/python/server/db/generated/sqla_media.py
sqlacodegen mysql://root:steel@localhost/media > $MILDRED_HOME/python/server/db/generated/sqla_media.py
sqlacodegen mysql://root:steel@localhost/analysis --tables action_dispatch,action,action_param,meta_action,meta_action_param,reason,reason_param,meta_reason,meta_reason_param,action_reason,m_action_m_reason > $MILDRED_HOME/python/server/db/generated/sqla_action.py
sqlacodegen mysql://root:steel@localhost/admin > $MILDRED_HOME/python/server/db/generated/sqla_admin.py
sqlacodegen mysql://root:steel@localhost/service > $MILDRED_HOME/python/server/db/generated/sqla_service.py
sqlacodegen mysql://root:steel@localhost/scratch > $MILDRED_HOME/python/server/db/generated/sqla_scratch.py

