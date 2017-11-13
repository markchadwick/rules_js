
def _uglify_impl(ctx):
  arguments = [
    '-o', ctx.outputs.js.path,
    ctx.file.src.path
  ]

  inputs, _, input_manifests = ctx.resolve_command(tools=[
    ctx.attr.src,
    ctx.attr._uglify,
  ])

  ctx.action(
    executable = ctx.executable._uglify,
    arguments  = arguments,
    inputs     = inputs,
    outputs    = [ctx.outputs.js],
    mnemonic   = 'Uglify',
    input_manifests = input_manifests,
  )

  return struct(
    files = depset([ctx.outputs.js]),
    runfiles = ctx.runfiles(files=[ctx.outputs.js]),
  )


uglify = rule(
  _uglify_impl,
  attrs = {
    'src':  attr.label(single_file=True),

    '_uglify': attr.label(
      default = Label('//uglify/toolchain:uglify'),
      cfg = 'target',
      executable = True),

  },
  outputs = {
    'js': '%{name}.js',
  }
)
