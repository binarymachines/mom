#! /bin/bash
pushd  /home/$USER/dev/mom
clear
#workon mom
python py/serv.py --pattern music
rm py/*.pyc
popd
pushd ~/dev/mom/
python py/launch.py
popd
