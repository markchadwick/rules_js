#!/bin/bash -eu

expected="4 doubled is 8"
actual=$(example/js/js_binary/simple-dep)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
