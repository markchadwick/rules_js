load('//js:def.bzl', 'compiled_js_binary')


DEFAULT_COMPILER = '@com_vistarmedia_rules_js//coffeescript/toolchain:coffeescript_js_compiler'


def coffeescript_binary(compiler=DEFAULT_COMPILER, **kwargs):
  compiled_js_binary(compiler=compiler, **kwargs)
