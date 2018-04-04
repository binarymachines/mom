#! /bin/bash

#~/dev/_virtual_env/mom/bin/python2.7 $MILDRED_HOME/python/server/desktop/cachemon.py --size 2000x75
clear
pushd $MILDRED_HOME/java/MildredCacheMonitor/
mvn compile
source run.sh
popd
