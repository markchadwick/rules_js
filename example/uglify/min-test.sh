#!/bin/bash -eu

PRE='./example/uglify/dist.js'
POST='./example/uglify/dist.min.js'

if ! [ -s $PRE ]; then
  echo "Expected $PRE to exist"
  exit 2
fi

if ! [ -s $POST ]; then
  echo "Expected $POST to exist"
  exit 2
fi

pre_size=$(wc -c $PRE | cut -d' ' -f1)
post_size=$(wc -c $POST | cut -d' ' -f1)

saved=$(echo $pre_size - $post_size | bc)
if [ $saved -lt 200000 ]; then
  echo "Can't believe we're only saving $saved bytes with this thing"
  exit 2
fi
