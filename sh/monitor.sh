#! /bin/bash

#~/dev/_virtual_env/mom/bin/python2.7 $M2/python/mildred/desktop/cachemon.py --size 2000x75
clear
pushd $M2/java/MildredCacheMonitor/
mvn compile
source run.sh
popd
