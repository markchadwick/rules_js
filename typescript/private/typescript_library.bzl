load('//js:def.bzl', 'compiled_js_library')

load(':typescript_compiler.bzl', 'DEFAULT_COMPILER')


def typescript_library(compiler=DEFAULT_COMPILER, **kwargs):
  compiled_js_library(compiler=compiler, **kwargs)
