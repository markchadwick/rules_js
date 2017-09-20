load('//coffeescript/private:coffeescript_compiler.bzl',
  'coffeescript_compiler')

def _coffeescript_sources_impl(ctx):
  srcs    = ctx.files.srcs
  outputs = []

  for src in srcs:
    if src.extension == 'coffee':
      js_name = src.basename.replace('.coffee', '.js')
      outputs.append(ctx.new_file(js_name))
    else:
      fail('Unknown extension', src.extension)

  ctx.action(
    mnemonic   = 'CompleCoffeescript',
    executable = ctx.executable.compiler,
    arguments  = [str(ctx.configuration.bin_dir.path)],
    inputs     = srcs,
    outputs    = outputs,
  )

  runfiles = ctx.runfiles(files=outputs)\
    .merge(ctx.attr.compiler.default_runfiles)

  return struct(
    files = set(outputs),
    runfiles = runfiles,
  )

_coffeescript_sources = rule(
  _coffeescript_sources_impl,
  attrs = {
    'srcs':     attr.label_list(allow_files=True),
    'compiler': attr.label(executable=True, cfg='host')
  }
)


def coffeescript_srcs(name, srcs, **kwargs):
  compiler_target = name + '.compiler'

  coffeescript_compiler(
    name = compiler_target,
    srcs = srcs,
  )

  _coffeescript_sources(
    name     = name,
    srcs     = srcs,
    compiler = compiler_target,
  )
