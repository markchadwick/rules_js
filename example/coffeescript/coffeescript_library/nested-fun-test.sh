#!/bin/bash -eu

FILENAME='./node_modules/example/coffeescript/coffeescript_library/nested/fun.js'

if ! [ -s $FILENAME ]; then
  echo "Expected $FILENAME to exist"
  exit 2
fi
