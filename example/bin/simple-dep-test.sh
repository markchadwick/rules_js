#!/bin/bash -eu

expected="4 doubled is 8"
actual=$(example/bin/simple-dep)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
