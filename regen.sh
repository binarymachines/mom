
#!/bin/bash
pushd $m2/python/mildred
export MILDRED_HOME=$m2/python/mildred
PYTHONPATH=`pwd`/python/mildred $m2/python/mildred/snap/routegen.py -g $m2/python/snap.conf > $m2/python/mildred/snap/main.py
popd
