load(':js_binary.bzl', 'js_binary')
load(':compiled_js_library.bzl', 'compiled_js_library')


def compiled_js_binary(name, src, visibility=None, **kwargs):
  lib_name = name + '.js_library'

  compiled_js_library(
    name = lib_name,
    srcs = [src],
    **kwargs)

  js_binary(
    name = name,
    src = ':' + lib_name,
    visibility = visibility)
