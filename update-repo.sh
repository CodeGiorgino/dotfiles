#!/usr/bin/env bash

echo 'Updating repository files...'
cat ./files.txt \
    | envsubst \
    | while read file; do cp $file .; done
