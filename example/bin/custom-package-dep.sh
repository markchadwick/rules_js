#!/bin/bash -eu

echo '---------------------------'
find -L .. -type f
echo '---------------------------'


expected="4 doubled is 8"
actual=$(example/bin/custom-package-dep)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
