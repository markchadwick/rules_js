load('//browserify:def.bzl', 'browserify')
load('//js:def.bzl', 'js_binary')
load('//uglify:def.bzl', 'uglify')

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

uglify(
  name = 'dist.min',
  src = ':dist',
)

sh_test(
  name = 'min-test',
  size = 'small',
  srcs = ['min-test.sh'],
  data = [
    ':dist',
    ':dist.min'
  ],
)
