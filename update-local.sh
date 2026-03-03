#!/usr/bin/env bash

echo 'Updating local files...'
cat ./files.txt \
    | envsubst \
    | while read file; do cp -r ./$(basename $file) $file; done
