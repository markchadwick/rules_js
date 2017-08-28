load('@io_bazel_rules_js//js/private:rules.bzl',
  'build_jsar',
  'node_driver',
  'transitive_jsars',
  'jsar_attr',
  'node_attr',
  'js_dep_attr')


def _js_test_impl(ctx):
  deps = ctx.attr.deps + [ctx.attr._mocha]

  jsar = build_jsar(ctx,
    files  = ctx.files.srcs,
    jsars  = transitive_jsars(deps),
    output = ctx.outputs.jsar,
  )

  arguments = [
    'node_modules/mocha/bin/mocha',
    '--timeout=%s' % ctx.attr.mocha_timeout
  ] + ['node_modules/%s' % src.short_path for src in ctx.files.srcs]

  node_driver(ctx,
    output    = ctx.outputs.executable,
    jsar      = jsar,
    node      = ctx.executable._node,
    arguments = arguments,
  )

  runfiles = ctx.runfiles(
    files = [
      ctx.executable._jsar,
      ctx.executable._node,
      jsar,
    ] + ctx.files.data,
    collect_default  = True,
  )

  return struct(
    files    = set([jsar, ctx.outputs.executable]),
    runfiles = runfiles,
  )


js_test = rule(
  _js_test_impl,
  test = True,
  attrs = {
    'srcs':          attr.label_list(allow_files=True),
    'deps':          js_dep_attr,
    'mocha_timeout': attr.string(default='0'),
    'data':          attr.label_list(allow_files=True, cfg='data'),
    '_node':         node_attr,
    '_jsar':         jsar_attr,
    '_mocha':        attr.label(default=Label('@mocha//:lib')),
  },
  outputs = {
    'jsar': '%{name}.jsar',
  },
)
