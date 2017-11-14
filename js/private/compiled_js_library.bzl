load(':js_library.bzl', 'js_library_result')


def _compiled_js_library_impl(ctx):
  srcs      = ctx.files.srcs
  compiler  = ctx.attr.compiler.compiler
  mnemonic  = ctx.attr.compiler.mnemonic
  transform = ctx.attr.compiler.transform
  package   = ctx.label.package + '/'
  outputs   = []

  for src in srcs:
    ext = '.' + src.extension
    for output_ext in transform[ext]:
      out_name = src.short_path.replace(package, '', 1)\
                               .replace(ext, output_ext, 1)
      out_file = ctx.actions.declare_file(out_name, sibling=src)
      outputs.append(out_file)

  arguments = ctx.attr.compiler.arguments + \
    [ctx.bin_dir.path] + \
    [src.path for src in srcs]

  tools = ctx.attr.deps + [compiler]
  inputs, _, input_manifests = ctx.resolve_command(tools=tools)

  ctx.actions.run(
    inputs     = inputs + srcs,
    outputs    = outputs,
    executable = compiler.files_to_run.executable,
    arguments  = arguments,
    mnemonic   = mnemonic,
    input_manifests = input_manifests,
  )

  return js_library_result(ctx, outputs)


compiled_js_library = rule(
  _compiled_js_library_impl,
  attrs = {
    'srcs':     attr.label_list(allow_files=True),
    'deps':     attr.label_list(providers=['_js_library_']),
    'package':  attr.string(),
    'compiler': attr.label(
      mandatory  = True,
      cfg        = 'host',
      providers  = ['transform', 'mnemonic', 'compiler'],
    ),
  },
)
