#!/bin/bash

pushd $M2/python/test

clear

for filename in ./*.py; do
    echo $filename
    /home/mpippins/.virtualenvs/mildred/bin/python2.7 "$filename"
done

popd
