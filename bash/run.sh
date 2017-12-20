#! /bin/bash

cat $MILDRED_HOME/python/log/errors.log >> $MILDRED_HOME/python/log/errors.log.bak
#rm $MILDRED_HOME/python/log/*.log
pushd $MILDRED_HOME/python
clear
PYTHONPATH=$MILDRED_HOME/python/mildred /home/$USER//Workspace/venv/mildred/bin/python2.7 $MILDRED_HOME/python/mildred/launch.py
popd
