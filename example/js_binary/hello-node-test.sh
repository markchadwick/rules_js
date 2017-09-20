#!/bin/bash -eu

# Because `node -p` evaluates the expression, it will first invoke the
# `console.log` then prints its return value, `undefined`.
expected="Hello World!
undefined"
actual=$(example/js_binary/hello-node)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
