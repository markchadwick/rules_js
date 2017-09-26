
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


def _symlinks(ctx, files):
  return {_symlink_path(ctx, f): f for f in files}


def _js_library_impl(ctx):
  srcs = ctx.files.srcs

  return struct(
    # files    = set(srcs),
    runfiles = ctx.runfiles(
      # files           = srcs,
      # root_symlinks   = _symlinks(ctx, srcs),
      symlinks = _symlinks(ctx, srcs),
      collect_default = True,
      collect_data    = True,
    ),
  )


js_library = rule(
  _js_library_impl,
  attrs = {
    'srcs':    attr.label_list(allow_files=True),
    'deps':    attr.label_list(),
    'package': attr.string(),
  },
)
