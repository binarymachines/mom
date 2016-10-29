#! /bin/bash

rm $MOM/py/*.pyc
#rm $MOM/logs/*.log
clear
cd $MOM
~/dev/_virtual_env/mom/bin/python2.7 $MOM/py/launch.py  --nomatch
