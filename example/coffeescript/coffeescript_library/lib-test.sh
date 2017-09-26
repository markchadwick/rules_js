#!/bin/bash -eu

FILENAME='./node_modules/example/coffeescript/coffeescript_library/simple_cs.js'

if ! [ -s $FILENAME ]; then
  echo "Expected $FILENAME to exist"
  exit 2
fi

expected=$(cat << _EOF_
(function() {
  module.exports.double = function(n) {
    return n * 2;
  };

}).call(this);
_EOF_
)
actual=$(cat $FILENAME)
if [ "$expected" != "$actual" ] ; then
  echo "Expected '${expected}' got '${actual}'"
  exit 2
fi
