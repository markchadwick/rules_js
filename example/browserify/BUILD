load('//js:def.bzl', 'js_binary')
load('//browserify:def.bzl', 'browserify')


js_binary(
  name = 'bin',
  src = 'bin.js',
  deps = [
    '@chai//:lib',
  ],
)

browserify(
  name = 'dist',
  entrypoint = ':bin',
)

sh_test(
  name = 'dist-dist',
  size = 'small',
  srcs = ['dist-test.sh'],
  data = [':dist'],
)
