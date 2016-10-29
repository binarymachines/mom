#! /bin/bash

rm $m2/py/*.pyc
#rm $MOM/logs/*.log
clear
cd $m2
~/dev/_virtual_env/mom/bin/python2.7 $MOM/py/launch.py  --nomatch
