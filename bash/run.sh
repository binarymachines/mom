#! /bin/bash

cat $MILDRED_HOME/python/log/errors.log >> $MILDRED_HOME/python/log/errors.log.bak
#rm $MILDRED_HOME/python/log/*.log
pushd $MILDRED_HOME/python
clear
PYTHONPATH=$MILDRED_HOME/python/mildred $HOME/workspace/venv/m2/bin/python2.7 $MILDRED_HOME/python/mildred/launch.py $1 $2 $3 $4 $5 $6 $7 $8 $9
popd
find $MILDRED_HOME/python -iname *.pyc -delete
