js_type          = FileType(['.js'])
js_tar_type      = FileType(['.tgz', '.tar.gz'])
js_dep_providers = ['js_tar', 'deps']
js_bin_providers = ['js_tar', 'deps', 'main']


def transitive_tars(ctx):
  tars = set(order='compile')
  for dep in ctx.attr.deps:
    tars += dep.deps | [dep.js_tar]
  return tars


def _js_tar_impl(ctx):
  js_tar = ctx.file.js_tar

  return struct(
    files  = set([js_tar]),
    js_tar = js_tar,
    deps   = transitive_tars(ctx),
  )


def _build_tar(ctx, files, tars, output):
  args = [
    '--output=' + output.path,
    '--directory=/',
    '--mode=0555',
    '--compression=gz',
  ] + [
    '--file=%s=%s' % (s.path, s.short_path) for s in ctx.files.srcs
  ] + [
    '--tar=%s' % t.path for t in tars
  ]
  arg_file = ctx.new_file('%s.args' % ctx.label.name)
  ctx.file_action(arg_file, '\n'.join(args))

  inputs = list(files) + list(tars) + [arg_file]

  ctx.action(
    executable = ctx.executable._build_tar,
    arguments  = ['--flagfile=' + arg_file.path],
    inputs     = inputs,
    outputs    = [output],
    mnemonic   = 'PackageJsTar',
  )

  return output


def _js_library_impl(ctx):
  js_tar = ctx.new_file('%s.tgz' % ctx.label.name)
  _build_tar(ctx, ctx.files.srcs, [], js_tar)

  return struct(
    files  = set([js_tar]),
    js_tar = js_tar,
    deps   = transitive_tars(ctx)
  )


def _js_binary_impl(ctx):
  js_tar = ctx.new_file('%s.tgz' % ctx.label.name)
  tars = transitive_tars(ctx)
  _build_tar(ctx, ctx.files.srcs, tars, js_tar)

  # TODO: This quotes arguments in double quotes. It's not entirely safe for
  # arbitrary inputs
  arguments = ' '.join(['"%s"' % arg for arg in ctx.attr.arguments])
  main      = "'require(\"%s\")'" % ctx.attr.main

  content = [
    '#!/bin/bash -eu',
    'set -o pipefail',
    'mkdir ./node_modules',
    'function _cleanup {',
    '  rm -rf ./node_modules',
    '}',
    'trap _cleanup EXIT',
    'tar -xzf %s -C ./node_modules' % js_tar.short_path,
    'NODEPATH=$PWD {node} -e {main} -- {args} "$@"'.format(
      node = ctx.executable._node.path,
      main = main,
      args = arguments,
    ),
  ]

  ctx.file_action(
    output     = ctx.outputs.executable,
    executable = True,
    content    = '\n'.join(content) + '\n',
  )

  runfiles = ctx.runfiles(
    files = ctx.files.srcs + [js_tar],
    transitive_files = set([ctx.executable._node]),
  )

  return struct(
    files    = set([js_tar, ctx.outputs.executable]),
    runfiles = runfiles,
    js_tar   = js_tar,
    main     = ctx.attr.main,
    deps     = set(order='compile'),
  )

# ------------------------------------------------------------------------------

_build_tar_attr = attr.label(
  default     = Label('@bazel_tools//tools/build_defs/pkg:build_tar'),
  cfg         = 'host',
  executable  = True,
  allow_files = True)

_node_attr = attr.label(
  default     = Label('//js/toolchain:node'),
  cfg         = 'host',
  executable  = True,
  allow_files = True)

_js_dep_attr = attr.label_list(providers=['js_tar', 'deps'])


js_tar = rule(
  _js_tar_impl,
  attrs = {
    'js_tar':  attr.label(
      allow_files = FileType(['.tgz', '.tar.gz']),
      single_file = True,
      mandatory   = True),
    'deps': _js_dep_attr,
  }
)

js_library = rule(
  _js_library_impl,
  attrs = {
    'srcs':       attr.label_list(allow_files=True),
    'deps':       _js_dep_attr,
    '_build_tar': _build_tar_attr,
  },
)

js_binary = rule(
  _js_binary_impl,
  executable = True,
  attrs = {
    'srcs':       attr.label_list(allow_files=True),
    'main':       attr.string(mandatory=True),
    'arguments':  attr.string_list(),
    'deps':       _js_dep_attr,
    '_build_tar': _build_tar_attr,
    '_node':      _node_attr
  },
)
