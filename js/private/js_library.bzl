
def _symlink_path(ctx, f):
  package = ctx.label.package
  workspace_root = ctx.label.workspace_root

  # Package names should ignore workspaces. If this symlink is from an external
  # workspace, rewrite it so that it appears local.
  if workspace_root:
    workspace_root += '/'
    path = f.path.replace(workspace_root, '', 1)
  else:
    path = f.short_path

  # Determine the node import. If a `package` is given, use that. Otherwise, use
  # the current target's path regardless of workspace.
  import_path = ctx.attr.package
  if not import_path:
    import_path = package

  # If the present package does not mesh with the import path, rewrite the
  # symlink path.
  if package != import_path:
    path = path.replace(package, import_path, 1)

  return 'node_modules/' + path


def js_library_result(ctx, srcs):
  symlinks = {_symlink_path(ctx, src): src for src in srcs}

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
  runfiles = ctx.runfiles(
    symlinks        = symlinks,
    collect_default = True,
    collect_data    = True,
  )

  return struct(
    files        = depset(srcs),
    runfiles     = runfiles,
    _js_library_ = True,
  )


def _js_library_impl(ctx):
  return js_library_result(ctx, ctx.files.srcs)


js_library = rule(
  _js_library_impl,
  attrs = {
    'srcs':    attr.label_list(allow_files=True),
    'deps':    attr.label_list(providers=['_js_library_']),
    'package': attr.string(),
  },
)
