
def external_name(name):
  return name\
    .replace('-', '.')\
    .replace('/', '_')\
    .replace('@', '_')


def _install_tarballs(ctx, tarballs):
  ctx.file('WORKSPACE', 'workspace(name="%s")\n' % ctx.name, False)

  root      = str(ctx.path('.'))
  installer = str(ctx.path(ctx.attr._npm_to_js_library))

  tarball_args = []
  for tarball in tarballs:
    tarball_args.append(struct(
      type = 'tarball',
      src  = tarball,
    ))

  args = struct(
    root        = root,
    name        = ctx.name,
    ignore_deps = ctx.attr.ignore_deps,
    deps        = tarball_args,
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

  return str(ctx.path(name))


def _npm_registry_url(package, version, namespace=None):
  url_safe_package = package.replace('/', '%2F')
  url_fragments = ['http://registry.npmjs.org']

  if namespace:
    url_fragments.append(namespace)

  url_fragments += [
    url_safe_package,
    '-',
    '%s-%s.tgz' % (url_safe_package, version),
  ]

  return '/'.join(url_fragments)

def _npm_install_impl(ctx):
  package, version, sha256 = ctx.attr.package, ctx.attr.version, ctx.attr.sha256

  tarballs = []
  url       = _npm_registry_url(package, version)
  file_name = '{package}-{version}.tgz'.format(package=package, version=version)
  path = _download_tarball(ctx,
    name   = file_name,
    url    = url,
    sha256 = ctx.attr.sha256,
  )
  tarballs.append(path)

  if ctx.attr.type_version:
    type_version = ctx.attr.type_version
    file_name = '{pkg}-{version}.tgz'.format(pkg=package, version=type_version)
    url       = _npm_registry_url(package, type_version, '@types')

    path = _download_tarball(ctx,
      name   = file_name,
      url    = url,
      sha256 = ctx.attr.type_sha256,
    )
    tarballs.append(path)

  _install_tarballs(ctx, tarballs)


def _npm_tarball_install_impl(ctx):
  path = _download_tarball(ctx,
    name   = 'lib.tgz',
    url    = ctx.attr.url,
    sha256 = ctx.attr.sha256,
  )
  _install_tarballs(ctx, [path])


_npm_install = repository_rule(
  implementation = _npm_install_impl,
  attrs = {
    'package':  attr.string(mandatory=True),
    'version':  attr.string(mandatory=True),
    'sha256':   attr.string(),

    'type_version': attr.string(),
    'type_sha256':  attr.string(),

    'ignore_deps': attr.string_list(),

    '_npm_to_js_library': attr.label(
      default     = Label('//js/tools:npm_to_js_library.py'),
      single_file = True,
      executable  = True,
      cfg         = 'host',
    )
  }
)

_npm_tarball_install = repository_rule(
  implementation = _npm_tarball_install_impl,
  attrs = {
    'url':     attr.string(mandatory=True),
    'sha256':  attr.string(),

    'ignore_deps': attr.string_list(),

    '_npm_to_js_library': attr.label(
      default     = Label('//js/tools:npm_to_js_library.py'),
      single_file = True,
      executable  = True,
      cfg         = 'host',
    )
  }
)

def npm_install(name, **kwargs):
  external = external_name(name)
  _npm_install(name=external, package=name, **kwargs)

def npm_tarball_install(name, **kwargs):
  external = external_name(name)
  _npm_tarball_install(name=external, **kwargs)
