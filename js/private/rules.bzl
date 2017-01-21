js_type          = FileType(['.js'])
js_tar_type      = FileType(['.tgz', '.tar.gz'])
js_dep_providers = ['js_tar', 'deps']


def transitive_tars(deps):
  tars = set(order='compile')
  for dep in deps:
    tars += dep.deps | [dep.js_tar]
  return tars


def _js_tar_impl(ctx):
  js_tar = ctx.file.js_tar

  return struct(
    files  = set([js_tar]),
    js_tar = js_tar,
    deps   = transitive_tars(ctx.attr.deps),
  )

def _js_tar_path(src):
  path = src.short_path
  if path.startswith('../'):
    return path[3:]
  return path

def build_tar(ctx, files, tars, output):
  args = [
    '--output=' + output.path,
    '--directory=/',
    '--mode=0555',
    '--compression=gz',
  ] + [
    '--file=%s=%s' % (s.path, _js_tar_path(s)) for s in files
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
  build_tar(ctx, ctx.files.srcs, [], js_tar)

  ts_defs = set()
  if ctx.attr.ts_defs:
    ts_defs = ctx.attr.ts_defs.ts_defs

  return struct(
    files   = set([js_tar]),
    js_tar  = js_tar,
    deps    = transitive_tars(ctx.attr.deps),
    ts_defs = ts_defs,
  )


def node_driver(ctx, output, js_tar, node, arguments=[]):
  safe_args = ["'%s'" % arg for arg in arguments]

  # Most generated js_tar files can be resolved relative to the working
  # directory of a binary (ie: A runfile). However, externals cannot. Try to
  # resolve the js_tar using the short path, but if it attempts to walk up a
  # directory, use the full path.
  js_tar_path = js_tar.short_path
  if js_tar_path.startswith('../'):
    js_tar_path = js_tar.path

  content = [
    '#!/bin/bash -eu',
    'set -o pipefail',
    'mkdir ./node_modules',
    'trap "{ rm -rf ./node_modules ; }" EXIT',
    'tar -xzf %s -C ./node_modules' % js_tar_path,
    'NODEPATH=$PWD {node} {arguments} "$@"'.format(
      node      = node.path,
      arguments = ' '.join(safe_args)
    ),
  ]

  ctx.file_action(
    output     = output,
    content    = '\n'.join(content),
    executable = True,
  )


def _js_binary_impl(ctx):
  js_tar = build_tar(ctx,
    files  = ctx.files.src,
    tars   = transitive_tars(ctx.attr.deps),
    output = ctx.outputs.js_tar
  )

  arguments = ['./node_modules/%s' % _js_tar_path(ctx.file.src)]

  node_driver(ctx,
    output    = ctx.outputs.executable,
    js_tar    = js_tar,
    node      = ctx.executable._node,
    arguments = arguments,
  )

  runfiles = ctx.runfiles(
    files = [js_tar],
    transitive_files = set([ctx.executable._node]),
  )

  return struct(
    files    = set([js_tar, ctx.outputs.executable]),
    runfiles = runfiles,
    js_tar   = js_tar,
    main     = ctx.file.src,
  )

# ------------------------------------------------------------------------------

build_tar_attr = attr.label(
  default     = Label('@bazel_tools//tools/build_defs/pkg:build_tar'),
  cfg         = 'host',
  executable  = True,
  allow_files = True)

node_attr = attr.label(
  default     = Label('//js/toolchain:node'),
  cfg         = 'host',
  executable  = True,
  allow_files = True)

js_dep_attr = attr.label_list(providers=js_dep_providers)


js_tar = rule(
  _js_tar_impl,
  attrs = {
    'js_tar':  attr.label(
      allow_files = FileType(['.tgz', '.tar.gz']),
      single_file = True,
      mandatory   = True),
    'deps': js_dep_attr,
  }
)

js_library = rule(
  _js_library_impl,
  attrs = {
    'srcs':       attr.label_list(allow_files=True),
    'deps':       js_dep_attr,
    'ts_defs':    attr.label(providers=['ts_defs']),
    '_build_tar': build_tar_attr,
  },
)

js_binary = rule(
  _js_binary_impl,
  executable = True,
  attrs = {
    'src':        attr.label(allow_files=True, single_file=True),
    'deps':       js_dep_attr,
    '_build_tar': build_tar_attr,
    '_node':      node_attr
  },
  outputs = {
    'js_tar': '%{name}.tar.gz',
  },
)
