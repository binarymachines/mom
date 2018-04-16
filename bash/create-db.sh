clear
cd $MILDRED_HOME/bash
rm $MILDRED_HOME/python/server/db/generated/*.p*

echo 'creating cuba db...'
mysql cuba  < $MILDRED_HOME/db/design/cuba.sql
echo 'creating media db...'
mysql cuba  < $MILDRED_HOME/db/design/media.sql
echo 'creating action db...'
mysql cuba < $MILDRED_HOME/db/design/analysis.sql
echo 'creating service db...'
mysql cuba < $MILDRED_HOME/db/design/service.sql
echo 'creating scratch db...'
mysql cuba < $MILDRED_HOME/db/design/scratch.sql

touch $MILDRED_HOME/python/server/db/__init__.py
touch $MILDRED_HOME/python/server/db/generated/__init__.py
sqlacodegen mysql://$1:$2@localhost/media > $MILDRED_HOME/python/server/db/generated/sqla_media.py
sqlacodegen mysql://$1:$2@localhost/media > $MILDRED_HOME/python/server/db/generated/sqla_media.py
# sqlacodegen mysql://$1:$2@localhost/analysis --tables dispatch,action,action_param,meta_action,meta_action_param,reason,reason_param,meta_reason,meta_reason_param,action_reason,m_action_m_reason > $MILDRED_HOME/python/server/db/generated/sqla_action.py
sqlacodegen mysql://$1:$2@localhost/analysis > $MILDRED_HOME/python/server/db/generated/sqla_analysis.py
#sqlacodegen mysql://$1:$2@localhost/admin > $MILDRED_HOME/python/server/db/generated/sqla_admin.py
sqlacodegen mysql://$1:$2@localhost/service > $MILDRED_HOME/python/server/db/generated/sqla_service.py
sqlacodegen mysql://$1:$2@localhost/scratch > $MILDRED_HOME/python/server/db/generated/sqla_scratch.py

# cat $MILDRED_HOME/python/server/db/generated/*.py
