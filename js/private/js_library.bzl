
def _symlink_path(ctx, f):
  if ctx.attr.package:
    return '/'.join([
      'node_modules',
      ctx.attr.package,
      f.path.replace(ctx.label.package, '', 1),
    ])
  return '/'.join([
      'node_modules',
      f.path,
  ])


def _js_library_impl(ctx):
  symlinks = {_symlink_path(ctx, f): f for f in ctx.files.srcs}

  runfiles = ctx.runfiles(
    root_symlinks   = symlinks,
    collect_default = True,
    collect_data    = True,
  )

  return struct(
    files    = set(ctx.files.srcs),
    runfiles = runfiles,
  )


js_library = rule(
  _js_library_impl,
  attrs = {
    'srcs':    attr.label_list(allow_files=True),
    'deps':    attr.label_list(),
    'package': attr.string(),
  },
)
