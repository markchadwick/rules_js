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
)

# js_binary(
#   name = 'csc-bin',
#   src  = 'csc.js',
#   deps = [
#     '@coffee.script//:lib',
#     '@mkdirp//:lib',
#   ],
# )

js_compiler(
  name       = 'coffeescript_js_compiler',
  compiler   = ':coffeescript_compiler',
  src_ext    = '.coffee',
  mnemonic   = 'CompileCoffeeScript',
  visibility = ['//visibility:public'],
)
# 
# js_binary(
#   name = 'cjsxc',
#   src  = 'cjsxc.js',
#   deps = [
#     '@coffee.react.transform//:lib',
#     '@coffee.script//:lib',
#     '@mkdirp//:lib',
#   ],
#   visibility = ['//visibility:public'],
# )

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
