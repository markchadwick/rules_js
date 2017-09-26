

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
    path += [f.short_path]

  return '/'.join(path)


def _symlinks(ctx, files):
  return {_symlink_path(ctx, f): f for f in files}

def js_library_result(ctx, srcs):
  # Hi.
  #
  # I know it's weird that the runfiles `files` is blank here. Bummer, right?
  # But you know what? It makes it so when you depend on one of these targets,
  # there's exactly one place you could ever see the file -- under node_modules,
  # not buried in the runfiles tree. Please, for the love of keeping things
  # simple, don't add `files` to the returned runfiles.
  #
  # Love you always,
  #   -Mark
  return struct(
    files = depset(srcs),
    runfiles = ctx.runfiles(
      symlinks = _symlinks(ctx, srcs),
      collect_default = True,
      collect_data    = True,
    ),
  )

def _js_library_impl(ctx):
  return js_library_result(ctx, ctx.files.srcs)


js_library = rule(
  _js_library_impl,
  attrs = {
    'srcs':    attr.label_list(allow_files=True),
    'deps':    attr.label_list(),
    'package': attr.string(),
  },
)
