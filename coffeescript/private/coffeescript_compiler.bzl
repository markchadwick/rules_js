load('//js:def.bzl', 'js_compiler')

def coffeescript_compiler(name,
    always_compile_cjsx = False,
    visibility = None):

  arguments = []
  if always_compile_cjsx:
    arguments.append('--always_compile_cjsx')

  js_compiler(
    name       = name,
    compiler   = '@com_vistarmedia_rules_js//coffeescript/toolchain:coffeescript_compiler',
    mnemonic   = 'CompileCoffeeScript',
    arguments  = arguments,
    visibility = visibility,
    transform  = {
      '.coffee':  ['.js'],
      '.cjsx':    ['.js'],
    },
  )
