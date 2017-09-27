load('//coffeescript:def.bzl', 'coffeescript_binary')

coffeescript_binary(
  name = 'bin',
  src  = 'bin.coffee',
  deps = [
    '//example/coffeescript/coffeescript_library:lib',
  ]
)

sh_test(
  name = 'bin-test',
  size = 'small',
  srcs = ['bin-test.sh'],
  data = [':bin'],
)
