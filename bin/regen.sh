
#!/bin/bash
pushd $M2/python/mildred
export MILDRED_HOME=$M2/python/mildred

PYTHONPATH=$M2/python/mildred $M2/python/mildred/snap/routegen.py -g $M2/python/snap.conf > $M2/python/mildred/snap/main.py
popd
