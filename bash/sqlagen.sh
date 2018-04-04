# clear
rm $MILDRED_HOME/python/mildred/db/generated/sqla_*.p*

touch $MILDRED_HOME/python/mildred/db/__init__.py
touch $MILDRED_HOME/python/mildred/db/generated/__init__.py
sqlacodegen mysql://root:steel@localhost/media > $MILDRED_HOME/python/mildred/db/generated/sqla_media.py
sqlacodegen mysql://root:steel@localhost/mildred > $MILDRED_HOME/python/mildred/db/generated/sqla_mildred.py
# sqlacodegen mysql://root:steel@localhost/mildred_action --tables action_dispatch,action,action_param,meta_action,meta_action_param,reason,reason_param,meta_reason,meta_reason_param,action_reason,m_action_m_reason > $MILDRED_HOME/python/mildred/db/generated/sqla_action.py
sqlacodegen mysql://root:steel@localhost/mildred_action > $MILDRED_HOME/python/mildred/db/generated/sqla_action.py
sqlacodegen mysql://root:steel@localhost/mildred_admin > $MILDRED_HOME/python/mildred/db/generated/sqla_admin.py
sqlacodegen mysql://root:steel@localhost/mildred_introspection > $MILDRED_HOME/python/mildred/db/generated/sqla_introspection.py
sqlacodegen mysql://root:steel@localhost/scratch > $MILDRED_HOME/python/mildred/db/generated/sqla_scratch.py

# cat $MILDRED_HOME/python/mildred/db/generated/*.py