load(':js_library.bzl', 'js_library_result')


def _compiled_js_library_impl(ctx):
  srcs     = ctx.files.srcs
  compiler = ctx.attr.compiler.compiler
  mnemonic = ctx.attr.compiler.mnemonic
  src_ext  = ctx.attr.compiler.src_ext
  package  = ctx.label.package + '/'
  outputs  = []

  for src in srcs:
    if src.extension == src_ext[1:]:
      out_name = src.short_path.replace(package, '', 1)\
        .replace(src.extension, 'js', 1)
      outputs.append(ctx.new_file(out_name))

    else:
      fail("%s doesn't have extension '%s'" % (src.path, src_ext))

  arguments = ctx.attr.compiler.arguments + \
    [ctx.bin_dir.path] + \
    [src.path for src in srcs]

  inputs, _, input_manifests = ctx.resolve_command(tools=[compiler])

  ctx.action(
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
    'package':  attr.string(),
    'compiler': attr.label(
      mandatory  = True,
      cfg        = 'host',
      providers  = ['src_ext', 'mnemonic', 'compiler'],
    ),
  },
)
