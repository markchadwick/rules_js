load('//js/private:npm_tarballs.bzl', 'npm_tarballs')


def npm_tarball_install(name, url, sha256=None, **kwargs):
  npm_tarballs(
    name    = name,
    names   = [name],
    urls    = [url],
    sha256s = [sha256],
    **kwargs)
