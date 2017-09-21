load('//js:def.bzl', 'compiled_js_library')

def coffeescript_library(**kwargs):
  compiled_js_library(
    compiler = '//coffeescript/toolchain:coffeescript_js_compiler',
    **kwargs)
