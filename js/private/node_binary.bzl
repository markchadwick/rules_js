
def _node_binary_impl(ctx):
  arguments = []
  for argument in ctx.attr.arguments:
    safeish = argument.replace("'", "\\'")
    arguments.append("'" + safeish + "'")

  content   = [
    '#!/bin/bash -eu',

    # Get full path of the script and set it to `$self`. If it isn't absolute,
    # prefix `$PWD` to ensure it is.
    'case "$0" in',
    '/*) self="$0" ;;',
    '*)  self="${PWD}/${0}" ;;',
    'esac',

    # When executing as a binary target, Bazel will place our runfiles in the
    # same name as this script with a '.runfiles' appended. When running as a
    # test, however, it will set the environment variable, $TEST_SRCDIR to the
    # value.
    'runfiles_root="${self}.runfiles"',
    'if [ -v TEST_SRCDIR ]; then',
    '   runfiles_root="$TEST_SRCDIR"',
    'fi',

    'export RUNFILES="${runfiles_root}/%s"' % ctx.workspace_name,
    'export NODE_PATH=../node_modules',

    # 'echo -------------------------------------------',
    # 'find -L $NODE_PATH -type f -maxdepth 4',
    # 'echo -------------------------------------------',

    'exec {node} {arguments} "$@"'.format(
      node      = ctx.executable._node.path,
      arguments = ' '.join(arguments)
    )
  ]

  ctx.file_action(
    output  = ctx.outputs.executable,
    content = '\n'.join(content),
  )

  runfiles = ctx.runfiles(
    files = ctx.files._node,
    collect_default = True,
    collect_data    = True,
  )

  return struct(
    files   = set([ctx.outputs.executable]),
    runfiles = runfiles,
  )

node_binary = rule(
  _node_binary_impl,
  executable = True,
  attrs = {
    'arguments': attr.string_list(),
    'deps':      attr.label_list(allow_files=True),

    '_node': attr.label(
      default    = Label('//js/toolchain:node'),
      executable = True,
      cfg = 'host'),
  },
)
