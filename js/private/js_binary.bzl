load('//js/private:node_binary.bzl',  'node_binary')
load('//js/private:js_library.bzl',  'js_library')


def js_binary(name, src, **kwargs):
  node_args  = kwargs.pop('arguments', [])
  visibility = kwargs.pop('visibility', None)
  lib_name   = name + '.lib'
  src_name   = name + '.src'

  js_library(
    name       = lib_name,
    srcs       = [src],
    visibility = visibility,
    **kwargs)

  native.filegroup(
    name       = src_name,
    srcs       = [src],
    visibility = visibility,
  )

  # TODO: `PACKAGE_NAME` will be deprecated for `native.package_name()` in a
  # near version of bazel
  entrypoint = PACKAGE_NAME +'/'+ src
  arguments  = [entrypoint] + node_args

  node_binary(
    name       = name,
    arguments  = arguments,
    deps       = [lib_name, src_name],
    visibility = visibility,
  )
