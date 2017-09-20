#!/bin/bash -eu

echo '-----------------------------------------'
find -L ..
echo '-----------------------------------------'

expected="Fart"
actual=$(echo "Fart")
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
