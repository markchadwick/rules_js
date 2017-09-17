
NODE_CONFIG = {
  'version': '6.2.2',
  'sha256': {
    'linux-x64':  '7a6df881183e70839857b51653811aaabc49a2ffb93416a1c9bd333dcef84ea3',
    'darwin-x64': '03b9eadd71d73daf2a25c8ea833454b326cb702f717a39f1b2a1324179cab5fa',
  },
}


def _install_node(arch):
  version = NODE_CONFIG['version']
  sha256  = NODE_CONFIG['sha256'][arch]
  name    = 'nodejs_' + arch.replace('-', '_')
  url     = 'https://nodejs.org/dist/v%s/node-v%s-%s.tar.gz' % (
    version,
    version,
    arch,
  )

  bin_path = 'node-v%s-%s/bin/node' % (version, arch)
  build_file_content = '\n'.join([
    'package(default_visibility=["//visibility:public"])',
    'filegroup(name="node", srcs=["%s"])' % bin_path,
  ])

  native.new_http_archive(
    name = name,
    url = url,
    sha256 = sha256,
    build_file_content = build_file_content,
  )


def js_repositories():
  _install_node('linux-x64')
  _install_node('darwin-x64')
