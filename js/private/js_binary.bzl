load('//js/private:node_binary.bzl',  'node_binary')
load('//js/private:js_library.bzl',  'js_library')


def js_binary(name, src, **kwargs):
  node_args  = kwargs.pop('arguments', [])
  visibility = kwargs.pop('visibility', None)
  lib_name   = name + '.lib'

  js_library(
    name       = lib_name,
    srcs       = [src],
    visibility = visibility,
    **kwargs)

  node_binary(
    name       = name,
    entrypoint = src,
    arguments  = node_args,
    deps       = [lib_name],
    visibility = visibility,
  )
