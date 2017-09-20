coffeescript_src_type = FileType(['.coffee'])

def _coffeescript_compiler_impl(ctx):
  compiler    = ctx.executable._csc
  srcs_by_dir = {}

  for src in ctx.files.srcs:
    dirname = src.dirname
    if not dirname in srcs_by_dir:
      srcs_by_dir[dirname] = [src]
    else:
      srcs_by_dir[dirname] += [src]

  content = [
    '#!/bin/bash -eux',
    'export RUNFILES="${0}.runfiles/%s"' % ctx.workspace_name,
  ]

  for dirname, srcs in srcs_by_dir.items():
    content.append(' '.join([
      '${RUNFILES}/' + ctx.executable._csc.short_path,
      # ctx.executable._csc.path,
      '--no-header',
      '--compile',
      '--output', '"$1"',
    ] + [
      src.path for src in srcs
    ]))

  ctx.file_action(
    output  = ctx.outputs.executable,
    content = '\n'.join(content),
  )

  runfiles = ctx.runfiles(
    files = ctx.files.srcs + ctx.files._csc + [ctx.outputs.executable],
  ).merge(ctx.attr._csc.default_runfiles)

  return struct(
    files    = set([ctx.outputs.executable]),
    runfiles = runfiles,
  )

coffeescript_compiler = rule(
  _coffeescript_compiler_impl,
  executable = True,
  attrs = {
    'srcs':  attr.label_list(allow_files=coffeescript_src_type),

    '_csc': attr.label(
      default    = Label('//coffeescript/toolchain:csc'),
      executable = True,
      cfg        = 'host'),
  }
)
