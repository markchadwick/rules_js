
def _install_tarball(ctx, tarball):
  root         = str(ctx.path('.'))
  tarball_path = str(ctx.path(tarball))
  installer    = str(ctx.path(ctx.attr._npm_to_js_library))

  args = struct(
    type = 'tarball',
    root = root,
    src  = tarball_path,
  )

  # TODO: add quiet=False
  ctx.execute([installer, args.to_json()])


def _download_tarball(ctx, name, url, sha256=None):
  # `ctx.download` is a direct Java method. Keyword arguments are not allowed
  # for this call.
  if sha256:
    ctx.download(url, name, sha256)
  else:
    ctx.download(url, name)

  return ctx.path(name)


def _npm_install_impl(ctx):
  package, version, sha256 = ctx.attr.package, ctx.attr.version, ctx.attr.sha256
  ctx.file('WORKSPACE', 'workspace(name="%s")\n' % ctx.name, False)

  file_name = '{package}-{version}.tgz'.format(package=package, version=version)
  url = 'http://registry.npmjs.org/{package}/-/{file_name}'.format(
    package   = package,
    file_name = file_name,
  )

  path = _download_tarball(ctx,
    name   = file_name,
    url    = url,
    sha256 = ctx.attr.sha256,
  )

  _install_tarball(ctx, file_name)


_npm_install = repository_rule(
  implementation = _npm_install_impl,
  attrs = {
    'package':  attr.string(mandatory=True),
    'version':  attr.string(mandatory=True),
    'sha256':   attr.string(),

    '_npm_to_js_library': attr.label(
      default     = Label('//js/tools:npm_to_js_library.py'),
      single_file = True,
      executable  = True,
      cfg         = 'host',
    )
  }
)

def npm_install(name, **kwargs):
  external = name\
    .replace('-', '.')

  _npm_install(name=external, package=name, **kwargs)
