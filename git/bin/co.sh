#!/usr/bin/env bash
REPO=${2:-mozilla-iam}/$1
if [ ! -d $1 ]; then
    echo cloning $REPO
    git clone https://github.com/$REPO
else
    echo $REPO already exists
fi