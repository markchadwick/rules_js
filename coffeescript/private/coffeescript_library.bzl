load('//js:def.bzl', 'compiled_js_library')


DEFAULT_COMPILER = '@com_vistarmedia_rules_js//coffeescript/toolchain:coffeescript_js_compiler'


def coffeescript_library(compiler=DEFAULT_COMPILER, **kwargs):
  compiled_js_library(compiler=compiler, **kwargs)
