load('//js:def.bzl', 'js_library')

package(default_visibility=['//visibility:public'])

js_library(
  name = 'double',
  srcs = ['double.js'],
)

js_library(
  name    = 'custom-package',
  package = 'cool-doubling',
  srcs    = ['double.js'],
)

js_library(
  name    = 'nested-package',
  package = 'cool-triple',
  srcs    = ['nested/triple.js'],
)
