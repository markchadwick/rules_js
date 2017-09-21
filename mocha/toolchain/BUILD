load('//js:def.bzl', 'node_binary')


node_binary(
  name = 'mocha',
  deps = ['@mocha//:lib'],
  arguments = [
    './external/mocha/mocha/bin/mocha',
  ],
  visibility = ['//visibility:public'],
)
