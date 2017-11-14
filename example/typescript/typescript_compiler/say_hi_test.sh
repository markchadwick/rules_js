#!/bin/bash -eu


expected=$(cat << _EOF_
"use strict";
exports.__esModule = true;
function sayHi(name) {
    console.log("Hello " + name + "!");
}
exports.sayHi = sayHi;
sayHi('asdf');
_EOF_
)
actual=$(cat ./node_modules/example/typescript/typescript_compiler/say_hi.js)

if [ "$actual" != "$expected" ]; then
  echo "Unexpected basic output"
  exit 2
fi
