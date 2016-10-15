#! /bin/bash
rm $MOM/py/*.pyc
rm $MOM/logs/*.log
source gbak
clear
~/dev/_virtual_env/mom/bin/python2.7 $MOM/py/launch.py
