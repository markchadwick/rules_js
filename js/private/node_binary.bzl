
def _node_binary_impl(ctx):
  arguments      = []
  runfiles_files = ctx.files._node + [ctx.outputs.executable]

  if ctx.file.entrypoint:
    arguments.append('${RUNFILES}/' + ctx.file.entrypoint.short_path)
    runfiles_files.append(ctx.file.entrypoint)

  for argument in ctx.attr.arguments:
    safeish = argument.replace("'", "\\'")
    arguments.append("'" + safeish + "'")

  content   = [
    '#!/bin/bash -eu',

    # When executing as a binary target, Bazel will place our runfiles in the
    # same name as this script with a '.runfiles' appended. When running as a
    # test, however, it will set the environment variable, $TEST_SRCDIR to the
    # value.
    'export runfiles_root="$0.runfiles"',
    'if [ -v TEST_SRCDIR ]; then',
    '   runfiles_root="$TEST_SRCDIR"',
    'fi',


    'export RUNFILES="${runfiles_root}/%s"' % ctx.workspace_name,

    'if [ -z ${NODE_PATH+x} ]; then',
    '  node_path="${RUNFILES}/node_modules"',
    'else',
    '  node_path="${RUNFILES}/node_modules:$NODE_PATH"',
    'fi',

    'export NODE_PATH="${node_path}"',
    'NODE="${RUNFILES}/%s"' % ctx.executable._node.path,

    'exec $NODE --prof {arguments} "$@"'.format(arguments=' '.join(arguments)),
  ]

  ctx.file_action(
    output  = ctx.outputs.executable,
    content = '\n'.join(content),
  )

  runfiles = ctx.runfiles(files=runfiles_files)

  for dep in ctx.attr.deps:
    runfiles = runfiles.merge(dep.default_runfiles)

  return struct(
    files = depset([ctx.outputs.executable]),
    runfiles = runfiles,
    entrypoint = ctx.file.entrypoint,
  )

node_binary = rule(
  _node_binary_impl,
  executable = True,
  attrs = {
    'arguments':  attr.string_list(),
    'entrypoint': attr.label(allow_files=True, single_file=True),
    'deps':      attr.label_list(allow_files=True),

    '_node': attr.label(
      default    = Label('//js/toolchain:node'),
      executable = True,
      cfg = 'host'),
  },
)
