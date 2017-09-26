#!/bin/bash -eu

COMPILED_JS='./node_modules/example/js/compiled_js_library/test_src.js'

expected="// Created by noop compiler"
actual=$(sed -n 1p $COMPILED_JS)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi

expected="module.exports COOL = 'party';"
actual=$(sed -n 2p $COMPILED_JS)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
