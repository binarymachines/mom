#! /bin/bash
pushd  /home/$USER/dev/mom
clear
#workon mom
python py/objman.py
rm py/*.pyc
popd
