#!/bin/bash -eu

expected="[ 'one', 'two', 'three' ]"
actual=$(example/bin/third-party-dep)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
