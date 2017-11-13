workspace(name='com_vistarmedia_rules_js')

load('//js:def.bzl', 'js_repositories')
js_repositories()

load('//coffeescript:def.bzl', 'coffeescript_repositories')
coffeescript_repositories()

load('//typescript:def.bzl', 'typescript_repositories')
typescript_repositories()

load('//mocha:def.bzl', 'mocha_repositories')
mocha_repositories()

load('//browserify:def.bzl', 'browserify_repositories')
browserify_repositories()

load('//uglify:def.bzl', 'uglify_repositories')
uglify_repositories()


load('//js:def.bzl', 'npm_install')
npm_install('lodash', version='4.17.4', type_version='4.14.71')
npm_install('leaflet', version='0.7.7', type_version='1.0.32',
  ignore_deps = ['@types/geojson'])


npm_install(
  name = 'chai',
  version = '4.1.2',
  sha256 = 'dd20186f63cf19bb6fb07de5fb3ee29ff4995ce716e9b76e4aee8d8b6dd9fd61',
)
npm_install(
  name = 'assertion-error',
  version = '1.0.2',
  sha256 = 'fcfb6f6be3104cb342819ca025bb310abab104fc90b882a1a2cddb4cd6139fb9',
)
npm_install(
  name = 'pathval',
  version = '1.1.0',
  sha256 = 'a950d68b409ee5daf91923ce180bab7dc1c93210ee29adbce1026be1ca04d541',
)
npm_install(
  name = 'type-detect',
  version = '4.0.3',
  sha256 = 'bd5451ee1c9dd7b815262a16d8e98c0cbcff7bc6b35595aa14a89ea6219b0c50',
)
npm_install(
  name = 'get-func-name',
  version = '2.0.0',
  sha256 = '791183ec55849b4e8fb87b356a6060d5a14dd72f1fe821750af8300e9afb4866',
)
npm_install(
  name = 'deep-eql',
  version = '3.0.1',
  sha256 = 'd0d75e7828b6b044cd81ddf332f03830b6f80e671495b265eee22a187a49c3a9',
)
npm_install(
  name = 'check-error',
  version = '1.0.2',
  sha256 = '92554b32cbf947c79e2832277ee730015408dd75e753ee320ba1fc7bf5915dda',
)

