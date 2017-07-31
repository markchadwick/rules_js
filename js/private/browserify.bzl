load('@io_bazel_rules_js//js/private:rules.bzl',
  'build_tar',
  'node_driver',
  'transitive_tars',
  'build_tar_attr',
  'node_attr',
  'js_dep_attr')


def _js_bundle_impl(ctx):
  deps = [ctx.attr.js_tar] + [ctx.attr._browserify] + [ctx.attr._uglify]

  js_tar = build_tar(ctx,
    files  = [],
    tars   = transitive_tars(deps),
    output = ctx.outputs.js_tar
  )

  entry_js = '%s/%s.js' % (ctx.file.entry.dirname,
                           '.'.join(ctx.file.entry.basename.split('.')[:-1]))

  arguments = [
    'node_modules/browserify/bin/cmd.js',
    '--ignore-transform', 'envify',
    '--ignore-transform', 'loose-envify',
    '--outfile',  ctx.outputs.bundle.path,
    './node_modules/%s' % entry_js,
  ]

  if ctx.attr.source_maps:
    arguments.append('--debug')

  content = [
    '#!/bin/bash -eu',
    'set -o pipefail',
    'mkdir ./node_modules',
    'trap "{ rm -rf ./node_modules ; }" EXIT',
    'tar -xzf "%s" -C ./node_modules' % js_tar.path,
    'NODEPATH=$PWD {node} {arguments} "$@"'.format(
      node      = ctx.executable._node.path,
      arguments = ' '.join(arguments)
    ),
  ]

  if ctx.attr.minified:
    content.append(
      'NODEPATH=$PWD {node} {arguments} "$@"'.format(
        node      = ctx.executable._node.path,
        arguments = 'node_modules/uglify-js/bin/uglifyjs -o {} {}'.format(
                      ctx.outputs.bundle.path,
                      ctx.outputs.bundle.path)
      ))

  ctx.action(
    mnemonic = 'Browserify',
    command  = '\n'.join(content),
    inputs   = [js_tar, ctx.executable._node],
    outputs  = [ctx.outputs.bundle],
  )

js_bundle = rule(
  _js_bundle_impl,
  attrs = {
    'entry':       attr.label(allow_files=True, single_file=True),
    'js_tar':      attr.label(),
    'minified':    attr.bool(default=False),
    'source_maps': attr.bool(default=False),
    '_node':       node_attr,
    '_build_tar':  build_tar_attr,
    '_browserify': attr.label(default=Label('@browserify//:lib')),
    '_uglify':     attr.label(default=Label('@uglifyjs//:lib')),
  },
  outputs = {
    'js_tar': '%{name}.tar.gz',
    'bundle': '%{name}.js',
  },
)
