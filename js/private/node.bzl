load('//js/private:npm.bzl', 'npm_install')

def _node_buildfile(arch):
  return '\n'.join([
    'package(default_visibility=["//visibility:public"])',
    'filegroup(name="node", srcs=["node-v6.2.2-%s/bin/node"])' % arch
  ])


def js_repositories():
  native.new_http_archive(
    name = 'nodejs_linux_amd64',
    url = 'https://nodejs.org/dist/v6.2.2/node-v6.2.2-linux-x64.tar.gz',
    sha256 = '7a6df881183e70839857b51653811aaabc49a2ffb93416a1c9bd333dcef84ea3',
    build_file_content = _node_buildfile('linux-x64'),
  )

  native.new_http_archive(
    name = 'nodejs_darwin_amd64',
    url = 'https://nodejs.org/dist/v6.2.2/node-v6.2.2-darwin-x64.tar.gz',
    sha256 = '03b9eadd71d73daf2a25c8ea833454b326cb702f717a39f1b2a1324179cab5fa',
    build_file_content = _node_buildfile('darwin-x64'),
  )

  # Grab Mocha + dependencies
  npm_install('graceful-readlink', version='1.0.1')
  npm_install('commander', version = '2.9.0')
  npm_install('ms', version='0.7.2')
  npm_install('debug', version='2.6.0')
  npm_install('diff', version='3.2.0')
  npm_install('has-flag', version='2.0.0')
  npm_install('supports-color', version='3.1.2')
  npm_install('escape-string-regexp', version='1.0.5')
  npm_install('path-is-absolute', version='1.0.1')
  npm_install('balanced-match', version='0.4.2')
  npm_install('concat-map', version='0.0.1')
  npm_install('brace-expansion', version='1.1.6')
  npm_install('minimatch', version = '3.0.3')
  npm_install('inflight', version='1.0.6')
  npm_install('wrappy', version='1.0.2')
  npm_install('once', version='1.4.0')
  npm_install('inherits', version='2.0.3')
  npm_install('fs.realpath', version='1.0.0')
  npm_install('glob', version = '7.1.1')
  npm_install('json3', version='3.3.2')
  npm_install(
    name        = 'mkdirp',
    version     = '0.5.1',
    ignore_deps = ['minimist']
  )
  npm_install('lodash.create', version='4.2.0')
  npm_install(
    name         = 'mocha',
    version      = '3.2.0',
    type_version = '2.2.37',
    ignore_deps  = [
      'browser.stdout',
      'growl',
    ]
  )
