#!/bin/bash -eu

expected="[ 'one', 'two', 'three' ]"
actual=$(example/js/js_binary/third-party-dep)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
