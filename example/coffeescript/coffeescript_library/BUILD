load('//coffeescript:def.bzl', 'coffeescript_library')

coffeescript_library(
  name = 'lib',
  srcs = ['simple_cs.coffee'],
)

sh_test(
  name = 'lib-test',
  size = 'small',
  srcs = ['lib-test.sh'],
  data = [':lib'],
)

coffeescript_library(
  name = 'nested-fun',
  srcs = ['nested/fun.coffee'],
)

sh_test(
  name = 'nested-fun-test',
  size = 'small',
  srcs = ['nested-fun-test.sh'],
  data = [':nested-fun'],
)
