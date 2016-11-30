#! /bin/bash

cat $M2/python/log/errors.log >> $M2/python/log/errors.log.bak
rm $M2/python/log/*.log
pushd $M2/python
clear
PYTHONPATH=$M2/python/mildred ~/dev/_virtual_env/mom/bin/python2.7 $M2/python/mildred/launch.py
popd
