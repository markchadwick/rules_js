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
    '//example/js/js_library:double',
  ],
)

sh_test(
  name = 'simple-dep-test',
  size = 'small',
  srcs = ['simple-dep-test.sh'],
  data = [':simple-dep'],
)

js_binary(
  name = 'custom-package-dep',
  src  = 'custom-package-dep.js',
  deps = [
    '//example/js/js_library:custom-package',
  ],
)

sh_test(
  name = 'custom-package-dep-test',
  size = 'small',
  srcs = ['custom-package-dep.sh'],
  data = [':custom-package-dep'],
)

js_binary(
  name = 'nested-package',
  src  = 'nested-package.js',
  deps = [
    '//example/js/js_library:nested-package',
  ],
)

sh_test(
  name = 'nested-package-test',
  size = 'small',
  srcs = ['nested-package-test.sh'],
  data = [':nested-package'],
)

js_binary(
  name = 'third-party-dep',
  src  = 'third-party-dep.js',
  deps = [
    '@lodash//:lib',
  ],
)

sh_test(
  name = 'third-party-dep-test',
  size = 'small',
  srcs = ['third-party-dep-test.sh'],
  data = [':third-party-dep'],
)
