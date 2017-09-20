#!/bin/bash -eu

echo '-----------------------------------------'
find -L .
echo '-----------------------------------------'

expected="expected"
actual=$(echo "actual")
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
