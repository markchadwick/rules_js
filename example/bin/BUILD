load('//js:def.bzl', 'node_binary')
load('//js:def.bzl', 'js_binary')

node_binary(
  name = 'hello-node',
  arguments = [
    '-p',
    'console.log("Hello World!")',
  ],
)

js_binary(
  name = 'hello-js',
  src  = 'hello-world.js',
)

js_binary(
  name = 'simple-dep',
  src  = 'simple-dep.js',
  deps = [
    '//example/lib:double',
  ],
)
