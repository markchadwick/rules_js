load('//js:def.bzl', 'js_binary')
load('//js:def.bzl', 'js_compiler')


js_binary(
  name = 'typescript_compiler',
  src  = 'tsc.js',
  deps = ['@typescript//:lib'],
)

js_compiler(
  name       = 'typescript_js_compiler',
  compiler   = ':typescript_compiler',
  mnemonic   = 'CompileTypeScript',
  visibility = ['//visibility:public'],
  transform  = {
    '.ts':  ['.js', '.d.ts'],
    '.tsx': ['.js', '.d.ts'],
  },
)
