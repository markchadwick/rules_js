load('//typescript:def.bzl', 'typescript_library')


typescript_library(
  name = 'doubler',
  srcs = ['doubler.ts'],
)

typescript_library(
  name = 'quadrupler',
  srcs = ['quadrupler.ts'],
  deps = [':doubler'],
)
