#!/bin/bash -eu

OUTPUT=$1
shift

while test ${#} -gt 0
do
  input=$1
  output="${OUTPUT}/$(dirname "$input")/$(basename "$input" .xxx).js"

  echo "// Created by noop compiler" >> $output
  cat $input >> $output
  shift
done
