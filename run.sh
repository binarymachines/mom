#! /bin/bash

cat $m2/python/log/errors.log >> $m2/python/log/errors.log.bak
rm $m2/python/log/*.log
pushd $m2/python
~/dev/_virtual_env/mom/bin/python2.7 $m2/python/mildred/launch.py  --nomatch
popd
