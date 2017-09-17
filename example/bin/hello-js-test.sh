#!/bin/bash -eu

expected="Hello World!"
actual=$(example/bin/hello-js)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
