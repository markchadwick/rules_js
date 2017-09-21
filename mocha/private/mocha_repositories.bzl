load('//js:def.bzl', 'npm_install')

def mocha_repositories():
  npm_install(
    name = 'mocha',
    version = '3.5.3',
    sha256 = 'ac31a50b8f90b6d353c452d1d81cf291670d21444d0c1a96fd47e3a8079327c3',
    ignore_deps = [
      'growl',
      'browser.stdout',
    ],
  )

  _glob_respositories()
  _debug_respositories()
  _supports_color_repositories()

  npm_install(
    name = 'commander',
    version = '2.11.0',
    sha256 = '32da223bd59643b0c19e76ce648aa2be502a4a9f7e092032edb15d8678285a00',
  )

  npm_install(
    name = 'mkdirp',
    version = '0.5.1',
    sha256 = '77b52870e8dedc68e1e7afcdadba34d3da6debe4f3aae36453ba151f1638bf24',
  )

  npm_install(
    name = 'escape-string-regexp',
    version = '1.0.5',
    sha256 = 'e50c792e76763d0c74506297add779755967ca9bbd288e2677966a6b7394c347',
  )

  npm_install(
    name = 'diff',
    version = '3.3.1',
    sha256 = 'fba1bd9afa7843fe5bba330a95b15d6ebb9bd885cc3e579722a4eacb2bd8e56c',
  )

  npm_install(
    name = 'json3',
    version = '3.3.2',
    sha256 = '703e754f648282fa455bd84a347d4105c9bb521c80983d54ec9f35f994558b5e',
  )

  npm_install(
    name = 'he',
    version = '1.1.1',
    sha256 = 'a5caab6aef32441afbfa10aae3969b9737e7b45cd84450e90b8728c27278c480',
  )

  npm_install(
    name = 'lodash.create',
    version = '4.2.0',
    sha256 = 'aeeb60f75c0906fda54ca19b17fb1af591eecd92c053e3dc4e54e360312f3fc6',
  )


def _supports_color_repositories():
  npm_install(
    name = 'supports-color',
    version = '4.4.0',
    sha256 = 'dada8a4f7b3a1920d3135416992b35ceb62d2f5434553d026c7a7773b60854f7',
  )

  npm_install(
    name = 'has-flag',
    version = '2.0.0',
    sha256 = '0915ab7bab71d000cd1ccb70b4e29afe1819183538339c8953bc9d3344bc4241',
  )


def _debug_respositories():
  npm_install(
    name = 'debug',
    version = '3.0.1',
    sha256 = '75301ee91bf3e2c65c23a1e849f4ba9a23afd9f634425621da7929ebb3fc6c73',
  )

  npm_install(
    name = 'ms',
    version = '2.0.0',
    sha256 = '362152ab8864181fc3359a3c440eec58ce3e18f773b0dde4d88a84fe13d73ecb',
  )


def _glob_respositories():
  npm_install(
    name = 'glob',
    version = '7.1.2',
    sha256 = 'cf3d3e47a1308b512fd707f1df593737cb569079d04bf975e1fc48de6a629ed1',
  )

  npm_install(
    name = 'inflight',
    version = '1.0.6',
    sha256 = '5a9fdcf59874af6ad3b413b6815d5afaaea34939a3bee20e1e50f7830031889b',
  )

  npm_install(
    name = 'once',
    version = '1.4.0',
    sha256 = 'cf51460ba370c698f68b976e514d113497339ba018b6003e8e8eb569c6fccfcf',
  )

  npm_install(
    name = 'wrappy',
    version = '1.0.2',
    sha256 = 'aff3730d91b7b1e143822956d14608f563163cf11b9d0ae602df1fe1e430fdfb',
  )

  npm_install(
    name = 'path-is-absolute',
    version = '1.0.1',
    sha256 = '6e6d709f1a56942514e4e2c2709b30c7b1ffa46fbed70e714904a3d63b01f75c',
  )

  npm_install(
    name = 'inherits',
    version = '2.0.3',
    sha256 = '7f5f58e9b54e87e264786e7e84d9e078aaf68c1003de9fa68945101e02356cdf',
  )

  npm_install(
    name = 'fs.realpath',
    version = '1.0.0',
    sha256 = '9e80cb8713125aa53df81a29626f7b81f26a9be1cd41840b3ccdcae4d52e8f9c',
  )

  npm_install(
    name = 'minimatch',
    version = '3.0.4',
    sha256 = '426a24d79bb6f0d3bb133e62cec69021836d254b39d931c104ddd7c464adea71',
  )

  npm_install(
    name = 'brace-expansion',
    version = '1.1.8',
    sha256 = '7dd8d0413f3c06f2e0f729e116c7df3b96420b4e12a124eb9e69861965b170fa',
  )

  npm_install(
    name = 'concat-map',
    version = '0.0.1',
    sha256 = '35902dd620cf0058c49ea614120f18a889d984269a90381b7622e79c2cfe4261',
  )

  npm_install(
    name = 'balanced-match',
    version = '1.0.0',
    sha256 = '2896602c12d3cef566bfbed7ccdef79232f4f1e00622fc5c9b40737465baffad',
  )
