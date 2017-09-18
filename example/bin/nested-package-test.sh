#!/bin/bash -eu

expected="4 tripled is 12"
actual=$(example/bin/nested-package)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
