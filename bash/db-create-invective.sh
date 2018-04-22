clear

cd $MILDRED_HOME/bash

echo 'creating cuba db...'
mysql -u root  < $MILDRED_HOME/db/design/cuba.sql

echo 'creating admin db...'
mysql -u root < $MILDRED_HOME/db/design/admin.sql

echo 'creating elastic db...'
mysql -u root < $MILDRED_HOME/db/design/elastic.sql

echo 'creating analysis db...'
mysql -u root < $MILDRED_HOME/db/design/analysis.sql

echo 'creating media db...'
mysql -u root  < $MILDRED_HOME/db/design/media.sql

echo 'creating service db...'
mysql -u root < $MILDRED_HOME/db/design/service.sql

echo 'creating suggestion db...'
mysql -u root < $MILDRED_HOME/db/design/suggestion.sql

echo 'creating mildred db...'
mysql -u root < $MILDRED_HOME/db/design/mildred.sql

echo 'creating scratch db...'
mysql -u root < $MILDRED_HOME/db/design/scratch.sql

echo 'updating SQLAlchemy classes...'
[[ -f $MILDRED_HOME/python/server/db/generated/*.p* ]] && rm $MILDRED_HOME/python/server/db/generated/*.p*
touch $MILDRED_HOME/python/server/db/__init__.py
touch $MILDRED_HOME/python/server/db/generated/__init__.py

sqlacodegen mysql://root:arecibo@localhost/admin > $MILDRED_HOME/python/server/db/generated/sqla_admin.py
sqlacodegen mysql://root:arecibo@localhost/analysis > $MILDRED_HOME/python/server/db/generated/sqla_analysis.py
sqlacodegen mysql://root:arecibo@localhost/scratch > $MILDRED_HOME/python/server/db/generated/sqla_scratch.py
sqlacodegen mysql://root:arecibo@localhost/elastic > $MILDRED_HOME/python/server/db/generated/sqla_elastic.py
sqlacodegen mysql://root:arecibo@localhost/media > $MILDRED_HOME/python/server/db/generated/sqla_media.py
sqlacodegen mysql://root:arecibo@localhost/service > $MILDRED_HOME/python/server/db/generated/sqla_service.py
sqlacodegen mysql://root:arecibo@localhost/suggestion > $MILDRED_HOME/python/server/db/generated/sqla_suggestion.py

# cat $MILDRED_HOME/python/server/db/generated/*.py
