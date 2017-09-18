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

  content = ['#!/bin/bash -eux']

  for dirname, srcs in srcs_by_dir.items():
    out_dir = ctx.configuration.bin_dir.path +'/'+ dirname
    content.append(' '.join([
      ctx.executable._csc.short_path,
      '--no-header',
      '--compile',
      '--output', out_dir,
    ] + [
      src.short_path for src in srcs
    ]))
    # csc should be ../com_vistarmedia_rules_js/coffeescript/toolchain/csc

  ctx.file_action(
    output  = ctx.outputs.executable,
    content = '\n'.join(content),
  )

  runfiles = ctx.runfiles(
    files=ctx.files.srcs + [ctx.outputs.executable],
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
