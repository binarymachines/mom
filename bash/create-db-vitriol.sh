clear
rm $MILDRED_HOME/python/server/db/generated/*.p*

echo 'updating media'
mysql cuba  < $MILDRED_HOME/db/design/media.sql
echo 'updating media action'
mysql cuba < $MILDRED_HOME/db/design/analysis.sql
echo 'updating media introspection'
mysql cuba < $MILDRED_HOME/db/design/service.sql
echo 'updating scratch'
mysql cuba < $MILDRED_HOME/db/design/scratch.sql

touch $MILDRED_HOME/python/server/db/__init__.py
touch $MILDRED_HOME/python/server/db/generated/__init__.py
sqlacodegen mysql://root:steel@localhost/media > $MILDRED_HOME/python/server/db/generated/sqla_media.py
sqlacodegen mysql://root:steel@localhost/media > $MILDRED_HOME/python/server/db/generated/sqla_media.py
# sqlacodegen mysql://root:steel@localhost/analysis --tables action_dispatch,action,action_param,meta_action,meta_action_param,reason,reason_param,meta_reason,meta_reason_param,action_reason,m_action_m_reason > $MILDRED_HOME/python/server/db/generated/sqla_action.py
sqlacodegen mysql://root:steel@localhost/analysis > $MILDRED_HOME/python/server/db/generated/sqla_analysis.py
#sqlacodegen mysql://root:steel@localhost/admin > $MILDRED_HOME/python/server/db/generated/sqla_admin.py
sqlacodegen mysql://root:steel@localhost/service > $MILDRED_HOME/python/server/db/generated/sqla_service.py
sqlacodegen mysql://root:steel@localhost/scratch > $MILDRED_HOME/python/server/db/generated/sqla_scratch.py

# cat $MILDRED_HOME/python/server/db/generated/*.py
