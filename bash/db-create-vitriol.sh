function create_schema {

  usage="create_schema [database]..."

  [ -z "$1" ] && echo $usage && return

    echo 'creating $1 db...'
    mysql -u root < $MILDRED_HOME/db/design/$1.sql
}

function regenerate_alchemy_classes {

  usage="regenerate_alchemy_classes [database]..."

  [ -z "$1" ] && echo $usage && return
    # echo 'creating $1 db...'
    sqlacodegen mysql://root:steel@localhost/$1 > $MILDRED_HOME/python/server/db/generated/sqla_$1.py
}

clear

cd $MILDRED_HOME/bash

echo 'dropping schemas...'
mysql -u root < $MILDRED_HOME/db/design/drop-all.sql

echo 'creating schemas...'

# create_schema admin
# create_schema elastic
# create_schema analysis
# create_schema media
# create_schema service
# create_schema suggestion
# create_schema mildred
# create_schema scratch

mysql -u root < $MILDRED_HOME/db/design/all-databases.sql


echo 'updating SQLAlchemy classes...'
[[ -f $MILDRED_HOME/python/server/db/generated/*.p* ]] && rm $MILDRED_HOME/python/server/db/generated/*.p*
touch $MILDRED_HOME/python/server/db/__init__.py
touch $MILDRED_HOME/python/server/db/generated/__init__.py

regenerate_alchemy_classes admin
regenerate_alchemy_classes analysis
regenerate_alchemy_classes elastic
regenerate_alchemy_classes media
regenerate_alchemy_classes service
regenerate_alchemy_classes suggestion
regenerate_alchemy_classes scratch

# cat $MILDRED_HOME/python/server/db/generated/*.py
