
#!/bin/bash
pushd $MILDRED_HOME/python/server
export MILDRED_HOME=$MILDRED_HOME/python/server

PYTHONPATH=$MILDRED_HOME/python/server $MILDRED_HOME/python/server/snap/routegen.py -g $MILDRED_HOME/python/snap.conf > $MILDRED_HOME/python/server/snap/main.py
popd
