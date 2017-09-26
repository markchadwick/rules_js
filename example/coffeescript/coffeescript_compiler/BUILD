load('//coffeescript:def.bzl',
  'coffeescript_compiler',
  'coffeescript_library')


coffeescript_compiler(
  name = 'cjsx_compiler',
  always_compile_cjsx = True,
)

coffeescript_library(
  name = 'has-cjsx',
  srcs = ['has_cjsx.coffee'],
  compiler = ':cjsx_compiler',
)
