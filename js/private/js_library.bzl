
def _symlink_path(ctx, f):
  path = ['node_modules']
  if ctx.attr.package:
    root = ctx.label.package
    workspace_root = ctx.label.workspace_root
    if workspace_root:
      root = ctx.label.workspace_root + '/' + root

    path += [
      ctx.attr.package,
      f.path.replace(root, '', 1),
    ]

  else:
    path.append(f.path)

  return '/'.join(path)


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
