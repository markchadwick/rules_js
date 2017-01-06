
def _external_name(name):
  """
  Bazel does not allow dashes in external names. Follow the convention of
  replacing dashes with dots. Consumers of NPM dependencies need to be aware of
  this rule
  """
  return name.replace('-', '.')


def _download_npm_tar(ctx, filename, package, version, namespace=None,
                      sha256=None):
  """
  Downloads a package and version to the specified `filename`. NPM clients have
  a weird convention of not-quite URL-escaping package names, but only replacing
  the `/` character with `%2F`. That convention is followed here.
  """
  url_safe_package = package.replace('/', '%2F')
  url_fragments = ['http://registry.npmjs.org']

  if namespace:
    url_fragments.append(namespace)

  url_fragments += [
    url_safe_package,
    '-',
    '%s-%s.tgz' % (url_safe_package, version),
  ]

  url = '/'.join(url_fragments)

  # `ctx.download` is a direct Java method. Keyword arguments are not allowed
  # for this call.
  if sha256:
    ctx.download(url, filename, sha256)
  else:
    ctx.download(url, filename)

  return filename


def _npm_install_impl(ctx):
  package       = ctx.attr.package
  version       = ctx.attr.version
  type_version  = ctx.attr.type_version
  ts_defs       = ctx.attr.ts_defs
  ignore_deps   = ctx.attr.ignore_deps

  ctx.file('WORKSPACE', "workspace(name='%s')\n" % ctx.name, False)
  npm_tar = _download_npm_tar(
    ctx      = ctx,
    filename = 'package.tgz',
    package  = package,
    version  = version,
    sha256   = ctx.attr.sha256
  )

  js_tar = ctx.file('lib.tgz')
  cmd = [
    ctx.path(ctx.attr._npm_to_js_tar),
    '--buildfile', ctx.path('BUILD'),
    '--js_tar',    ctx.path('lib.tgz'),
    '--npm_tar',   ctx.path(npm_tar),
  ]
  if ignore_deps:
    cmd += ['--ignore_deps'] + ignore_deps
  if ts_defs:
    cmd += ['--ts_defs'] + [ctx.path(ts_def) for ts_def in ts_defs]

  # If a @types version has been supplied, download that tarball from NPM and
  # append the argument to `npm_to_js_tar`
  if type_version:
    types_tar = _download_npm_tar(
      ctx       = ctx,
      filename  = 'types.tgz',
      package   = package,
      version   = type_version,
      sha256    = ctx.attr.type_sha256,
      namespace = '@types'
    )
    cmd += ['--types_tar', ctx.path(types_tar)]


  ctx.execute(cmd)


_npm_install = repository_rule(
  _npm_install_impl,
  attrs = {
    'package':      attr.string(mandatory=True),
    'version':      attr.string(mandatory=True),
    'sha256':       attr.string(mandatory=False),
    'ts_defs':      attr.label_list(default=[]),
    'type_version': attr.string(mandatory=False),
    'type_sha256':  attr.string(mandatory=False),
    'ignore_deps':  attr.string_list(),

    '_npm_to_js_tar': attr.label(
      default    = Label('//js/tools:npm_to_js_tar.py'),
      cfg        = 'host',
      executable = True),
  },
)

def npm_install(name, **kwargs):
  """
  Sanitizes the given name and creates a sanitized external target using the
  `_npm_install` rule.
  """
  external = _external_name(name)
  return _npm_install(name=external, package=name, **kwargs)
