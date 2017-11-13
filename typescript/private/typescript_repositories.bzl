load('//js:def.bzl', 'npm_install')


def typescript_repositories():
  npm_install(
    name = 'typescript',
    version = '2.6.1',
    sha256 = '62b4de36dbb0a41339ad111d3845f226e2d968cac47097f35291f38b88f6c2a6',
  )
