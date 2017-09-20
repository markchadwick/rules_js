load('//js:def.bzl', 'js_compiler')
load('//js/private:compiled_js_library.bzl', 'compiled_js_library')

sh_binary(
  name = 'noop_compiler',
  srcs = ['noop_compiler.sh']
)

js_compiler(
  name      = 'noop',
  compiler  = ':noop_compiler',
  mnemonic  = 'NoopCompile',
  src_ext   = '.xxx',
)

compiled_js_library(
  name     = 'lib',
  srcs     = ['test_src.xxx'],
  compiler = ':noop',
)

sh_test(
  name = 'compiler-test',
  size = 'small',
  srcs = ['compiler-test.sh'],
  data = [':lib']
)
