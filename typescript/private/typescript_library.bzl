load('//js:def.bzl', 'compiled_js_library')


DEFAULT_COMPILER = '@com_vistarmedia_rules_js//typescript/private:default_compiler'

def typescript_library(compiler=DEFAULT_COMPILER, **kwargs):
  compiled_js_library(compiler=compiler, **kwargs)
