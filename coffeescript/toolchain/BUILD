load('//js:def.bzl', 'js_binary')
load('//js:def.bzl', 'js_compiler')
load('//mocha:def.bzl', 'mocha_test')

js_binary(
  name = 'coffeescript_compiler',
  src  = 'coffeescript_compiler.js',
  deps = [
    '@coffee.react.transform//:lib',
    '@coffee.script//:lib',
    '@mkdirp//:lib',
  ],
  visibility = ['//visibility:public'],
)

js_compiler(
  name       = 'coffeescript_js_compiler',
  compiler   = ':coffeescript_compiler',
  mnemonic   = 'CompileCoffeeScript',
  visibility = ['//visibility:public'],
  transform  = {
    '.coffee':  ['.js'],
    '.cjsx':    ['.js'],
  },
)

mocha_test(
  name = 'test',
  size = 'small',
  srcs = [
    'coffeescript_compiler_spec.js',
  ],
  deps = [
    ':coffeescript_compiler.lib',

    '@chai//:lib',
  ],
)
