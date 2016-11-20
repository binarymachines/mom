#! /bin/bash

cat $m2/python/log/errors.log >> $m2/python/log/errors.log.bak
rm $m2/python/log/*.log
pushd $m2/python
clear
PYTHONPATH=$m2/python/mildred ~/dev/_virtual_env/mom/bin/python2.7 $m2/python/mildred/launch.py
popd
