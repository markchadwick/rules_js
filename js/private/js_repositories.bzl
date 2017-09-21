
# Current "bleeding-edge" node version
CURRENT_CONFIG = {
  'version': '8.5.0',
  'sha256': {
    'linux-x64':  '0000710235e04553147b9c18deadc7cefa4297d4dce190de94cc625d2cf6b9ba',
    'darwin-x64': '0c8d4c4d90f858a19a29fe1ae7f42b2b7f1a4d3caaa25bea2e08479c00ebbd5f',
  }
}

# Long Term Support version of Node
LTS_CONFIG = {
  'version': '6.11.3',
  'sha256': {
    'linux-x64':  '610705d45eb2846a9e10690678a078d9159e5f941487aca20c6f53b33104358c',
    'darwin-x64': 'be80751e600b37f2228170fe5eeb04d6f0febb6076f586310685ea2a34e558fb',
  },
}

# Sets the current configuration to the "Bleeding-edge" current version
NODE_CONFIG = CURRENT_CONFIG

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
