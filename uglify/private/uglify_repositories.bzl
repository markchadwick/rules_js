load('//js:def.bzl', 'npm_tarball_install')

def uglify_repositories():
  """
  TODO: This is kinda gross
  """
  npm_tarball_install(
    name = 'uglifyjs',
    url = 'https://s3.amazonaws.com/js.vistarmedia.com/uglify-js-3.0.24.tgz',
    sha256 = 'afc191cfb99b252d750fdae86bcd0e1e74a764a470d0298ffb6655322ae9a50f',
    ignore_deps = [
      'commander',
      'source-map',
    ]
  )
