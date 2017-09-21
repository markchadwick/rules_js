load('//js:def.bzl', 'js_binary')
load('//js:def.bzl', 'js_compiler')

js_binary(
  name = 'coffeescript_compiler',
  src  = 'coffeescript_compiler.js',
  deps = [
    '@coffee.script//:lib',
    '@mkdirp//:lib',
  ],
)

js_binary(
  name = 'csc-bin',
  src  = 'csc.js',
  deps = [
    '@coffee.script//:lib',
    '@mkdirp//:lib',
  ],
)

js_compiler(
  name       = 'csc',
  compiler   = ':csc-bin',
  src_ext    = '.coffee',
  mnemonic   = 'CompileCoffeeScript',
  visibility = ['//visibility:public'],
)

js_binary(
  name = 'cjsxc',
  src  = 'cjsxc.js',
  deps = [
    '@coffee.react.transform//:lib',
    '@coffee.script//:lib',
    '@mkdirp//:lib',
  ],
  visibility = ['//visibility:public'],
)
