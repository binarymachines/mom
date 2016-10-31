#! /bin/bash

cat $m2/log/errors.log >> $m2/log/errors.log.bak
rm $m2/log/*.log
pushd $m2/python
~/dev/_virtual_env/mom/bin/python2.7 $m2/python/mildred/launch.py  --nomatch
popd
