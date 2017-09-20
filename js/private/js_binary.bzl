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

  src_name = src
  # native.filegroup(
  #   name       = src_name,
  #   srcs       = [src],
  #   visibility = visibility,
  # )

  # TODO: `PACKAGE_NAME` will be deprecated for `native.package_name()` in a
  # near version of bazel
  # entrypoint = '/'.join([
  #   '$(location :%s)', 
  #   PACKAGE_NAME,
  #   src,
  # ])
  # entrypoint = '$(location :%s)' % src_name
  # arguments = [entrypoint] + node_args

  node_binary(
    name       = name,
    entrypoint = src_name,
    arguments  = node_args,
    deps       = [lib_name, src_name],
    visibility = visibility,
  )
