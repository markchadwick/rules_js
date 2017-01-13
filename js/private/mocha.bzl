load('@io_bazel_rules_js//js/private:rules.bzl',
  'build_tar',
  'node_driver',
  'transitive_tars',
  'build_tar_attr',
  'node_attr',
  'js_dep_attr')


def _js_test_impl(ctx):
  deps = ctx.attr.deps + [ctx.attr._mocha]

  js_tar = build_tar(ctx,
    files  = ctx.files.srcs,
    tars   = transitive_tars(deps),
    output = ctx.outputs.js_tar
  )

  arguments = [
    'node_modules/mocha/bin/mocha'
  ] + ['node_modules/%s' % src.path for src in ctx.files.srcs]

  node_driver(ctx,
    output    = ctx.outputs.executable,
    js_tar    = js_tar,
    node      = ctx.executable._node,
    arguments = arguments,
  )

  runfiles = ctx.runfiles(
    files = [js_tar, ctx.outputs.executable],
    transitive_files = set([ctx.executable._node]),
  )

  return struct(
    files    = set([js_tar, ctx.outputs.executable]),
    runfiles = runfiles,
  )


js_test = rule(
  _js_test_impl,
  test = True,
  attrs = {
    'srcs':       attr.label_list(allow_files=True),
    'deps':       js_dep_attr,
    '_node':      node_attr,
    '_build_tar': build_tar_attr,
    '_mocha':     attr.label(default=Label('@mocha//:lib')),
  },
  outputs = {
    'js_tar': '%{name}.tar.gz',
  },
)
