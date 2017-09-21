load('//js:def.bzl', 'npm_install')

def mocha_repositories():
  npm_install(
    name    = 'mocha',
    version = '3.5.3',
    sha256  = 'ac31a50b8f90b6d353c452d1d81cf291670d21444d0c1a96fd47e3a8079327c3',
  )
