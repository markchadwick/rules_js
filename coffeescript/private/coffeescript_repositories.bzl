load('//js:def.bzl', 'npm_install')


def coffeescript_repositories():
  npm_install(
    name = 'coffee-script',
    version = '1.12.7',
    sha256 = 'f86e3c117e3402b3e505ad3272b961549e3a1bad518f10b4f7ddea6b5068c320',
  )
  npm_install(
    name = 'mkdirp',
    version = '0.5.1',
    sha256 = '77b52870e8dedc68e1e7afcdadba34d3da6debe4f3aae36453ba151f1638bf24',
    ignore_deps = ['minimist']
  )
  npm_install(
    name = 'coffee-react-transform',
    version = '5.0.0',
    sha256 = '77179d54989962d3d83811ca9df007d6e56a05c91f4688285f0c4938860a3d8d',
  )

