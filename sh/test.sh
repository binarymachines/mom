#!/bin/bash

pushd $m2/python/test

clear

for filename in ./*.py; do
    echo $filename
    python "$filename"
done

popd
