load('//typescript:def.bzl',
  'typescript_compiler',
  'typescript_library')


typescript_compiler(name='tsc-basic')

typescript_library(
  name = 'basic',
  srcs = ['say_hi.ts'],
  compiler = ':tsc-basic',
)

sh_test(
  name = 'basic_test',
  size = 'small',
  srcs = ['say_hi_test.sh'],
  data = [':basic'],
)

typescript_compiler(
  name = 'jsx-compiler',
  arguments = [
    '--jsx', 'react',
  ],
)

typescript_library(
  name = 'jsx',
  srcs = ['jsx.tsx'],
  compiler = ':jsx-compiler',
)
