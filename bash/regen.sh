
#!/bin/bash
pushd $MILDRED_HOME/python/mildred
export MILDRED_HOME=$MILDRED_HOME/python/mildred

PYTHONPATH=$MILDRED_HOME/python/mildred $MILDRED_HOME/python/mildred/snap/routegen.py -g $MILDRED_HOME/python/snap.conf > $MILDRED_HOME/python/mildred/snap/main.py
popd
