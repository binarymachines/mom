#!/bin/bash

pushd $M2/python/test

clear

for filename in ./*.py; do
    echo $filename
    python "$filename"
done

popd
