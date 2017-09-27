#!/bin/bash -eu

expected="4 doubled is 8"
actual=$(example/coffeescript/coffeescript_binary/bin)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
