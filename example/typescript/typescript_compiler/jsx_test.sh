#!/bin/bash -eu

expected=$(cat << _EOF_
"use strict";
exports.__esModule = true;
var React = {};
exports.BigName = function (props) {
    React.createElement("h1", null, props.name);
};

_EOF_
)
actual=$(cat ./node_modules/example/typescript/typescript_compiler/jsx.js)

if [ "$actual" != "$expected" ]; then
  echo "Unexpected jsx output"
  exit 2
fi
