#!/usr/bin/env bash

function generate {

  usage="generate [database]..."

  [ -z "$1" ] && echo $usage && return

  [[ -e $MILDRED_HOME/db/design/$1.sql ]] && rm -v $MILDRED_HOME/db/design/$1.sql

  echo "drop schema if exists $1;" > $MILDRED_HOME/db/design/$1.sql
  echo "create schema $1;" >> $MILDRED_HOME/db/design/$1.sql
  echo "use $1;" >> $MILDRED_HOME/db/design/$1.sql
  echo >> $MILDRED_HOME/db/design/$1.sql

  mysqldump $1 >> $MILDRED_HOME/db/design/$1.sql --add-drop-table --complete-insert
  [[ -e $MILDRED_HOME/db/design/$1.sql ]] && echo "created '$MILDRED_HOME/db/design/$1.sql'"
}

generate admin
generate analysis
generate elastic
generate media
generate mildred
generate service
generate scratch
generate suggestion

