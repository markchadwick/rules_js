def _node_buildfile(arch):
  return '\n'.join([
    'package(default_visibility=["//visibility:public"])',
    'filegroup(name="node", srcs=["node-v6.2.2-%s/bin/node"])' % arch
  ])


def node_repositories():
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
