load('@io_bazel_rules_js//js:def.bzl', 'js_binary')

config_setting(
  name = 'k8',
  values = {'host_cpu': 'k8'},
)

config_setting(
  name = 'darwin',
  values = {'host_cpu': 'darwin'},
)

filegroup(
  name = 'node',
  srcs = select({
    ':k8':      ['@nodejs_linux_amd64//:node'],
    ':darwin':  ['@nodejs_darwin_amd64//:node'],
  }),
  visibility = ['//visibility:public'],
)

js_binary(
  name = 'uglify',
  src  = 'uglify.js',
  deps = ['@uglifyjs//:lib'],
  visibility = ['//visibility:public'],
)

exports_files(['browserify.js'])
