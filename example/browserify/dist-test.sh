#!/bin/bash -eu

FILENAME='./example/browserify/dist.js'

if ! [ -s $FILENAME ]; then
  echo "Expected $FILENAME to exist"
  exit 2
fi
