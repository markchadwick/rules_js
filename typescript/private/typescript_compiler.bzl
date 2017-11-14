load('//js:def.bzl', 'js_compiler')


def typescript_compiler(name,
  arguments = [],
  visibility = None):

  inputs  = ['.ts']
  outputs = ['.js']

  # Allow .tsx files when the compiler has a jsx transform
  if '--jsx' in arguments:
    inputs.append('.tsx')

  # Add type declarations to the transform when given as arguments
  if '--declaration' in arguments or '-d' in arguments:
    outputs.append('.d.ts')

  transform = {}
  for ext in inputs:
    transform[ext] = outputs

  config = struct(
    arguments = arguments,
  )

  js_compiler(
    name       = name,
    compiler   = '@com_vistarmedia_rules_js//typescript/toolchain:typescript_compiler',
    mnemonic   = 'CompileTypeScript',
    arguments  = ['--config', config.to_json()],
    visibility = visibility,
    transform  = transform,
  )
