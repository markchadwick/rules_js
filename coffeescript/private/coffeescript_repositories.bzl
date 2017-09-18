load('//js:def.bzl', 'npm_install')


def coffeescript_repositories():
  npm_install('coffee-script', version='1.12.2')
  npm_install('coffee-react-transform', version='4.0.0')
  npm_install('mkdirp', version='0.5.1', ignore_deps=[
    'minimist',
  ])
