

def _mocha_test_impl(ctx):
  command = ' '.join([
    ctx.executable._mocha.short_path
  ] + [src.short_path for src in ctx.files.srcs])

  content = [
    '#!/bin/bash -eu',
    command,
  ]

  ctx.file_action(
    output  = ctx.outputs.executable,
    content = '\n'.join(content),
  )

  runfiles = ctx.runfiles(
    files = [ctx.outputs.executable] + ctx.files.srcs,
    collect_default = True,
    collect_data    = True,
  ).merge(ctx.attr._mocha.default_runfiles)

  return struct(
    files = depset([ctx.outputs.executable]),
    runfiles = runfiles,
  )


mocha_test = rule(
  _mocha_test_impl,
  test = True,
  attrs = {
    'srcs': attr.label_list(allow_files=True),
    'deps': attr.label_list(),
    '_mocha': attr.label(
      default    = Label('//mocha/toolchain:mocha'),
      cfg        = 'host',
      executable = True,
    ),
  }
)
