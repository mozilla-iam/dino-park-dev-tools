#!/usr/bin/env bash
pushd $1
git checkout master
git pull origin master
popd