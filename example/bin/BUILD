load('//js:def.bzl', 'node_binary')
load('//js:def.bzl', 'js_binary')

node_binary(
  name = 'hello-node',
  arguments = [
    '-p',
    'console.log("Hello World!")',
  ],
)

sh_test(
  name = 'hello-node-test',
  size = 'small',
  srcs = ['hello-node-test.sh'],
  data = [':hello-node'],
)

js_binary(
  name = 'hello-js',
  src  = 'hello-world.js',
)

sh_test(
  name = 'hello-js-test',
  size = 'small',
  srcs = ['hello-js-test.sh'],
  data = [':hello-js'],
)

js_binary(
  name = 'simple-dep',
  src  = 'simple-dep.js',
  deps = [
    '//example/lib:double',
  ],
)

sh_test(
  name = 'simple-dep-test',
  size = 'small',
  srcs = ['simple-dep-test.sh'],
  data = [':simple-dep'],
)
