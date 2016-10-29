#! /bin/bash
rm $m2/py/*.pyc
rm $m2/logs/*.log
clear
~/dev/_virtual_env/mom/bin/python2.7 $m2/py/launch.py --reset --exit
