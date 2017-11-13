
def _browserify_impl(ctx):
  browserify = ctx.attr._browserify
  entrypoint = ctx.attr.entrypoint

  entry = ctx.attr.entrypoint.entrypoint.short_path\
    .replace('.js', '')

  arguments = [
    '--ignore-transform', 'envify',
    '--ignore-transform', 'loose-envify',
    '--outfile',  ctx.outputs.js.path,
    '--require', entry,
  ]

  if ctx.attr.source_maps:
    arguments.append('--debug')

  entry_node_modules = '/'.join([
    './bazel-out/host/bin', # TODO: this is hacky
    entrypoint.label.package,
    entrypoint.label.name + '.runfiles',
    ctx.workspace_name,
    'node_modules',
  ])

  inputs, _, input_manifests = ctx.resolve_command(tools=[
    browserify,
    ctx.attr.entrypoint,
  ])

  ctx.action(
    executable = ctx.executable._browserify,
    arguments  = arguments,
    inputs     = inputs,
    outputs    = [ctx.outputs.js],
    mnemonic   = 'Browserify',
    env        = {'NODE_PATH': entry_node_modules},
    input_manifests = input_manifests,
  )

  return struct(
    files = depset([ctx.outputs.js]),
    runfiles = ctx.runfiles(files=[ctx.outputs.js]),
  )


browserify = rule(
  _browserify_impl,
  attrs = {
    'entrypoint':  attr.label(executable=True, cfg='host', providers=['entrypoint']),
    'source_maps': attr.bool(default=False),

    '_browserify': attr.label(
      default = Label('//browserify/toolchain:browserify'),
      cfg = 'target',
      executable = True),

  },
  outputs = {
    'js': '%{name}.js',
  }
)
