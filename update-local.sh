#!/usr/bin/env bash

echo 'Updating local files...'
cat ./files.txt \
    | envsubst \
    | while read file; do cp ./$(basename $file) $file; done
