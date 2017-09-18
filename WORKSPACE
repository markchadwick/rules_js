workspace(name='com_vistarmedia_rules_js')

load('//js:def.bzl', 'js_repositories')
js_repositories()

load('//js/private:npm_install.bzl', 'npm_install')
npm_install('lodash', version='4.17.4', type_version='4.14.71')
npm_install('leaflet', version='0.7.7', type_version='1.0.32',
  ignore_deps = ['@types/geojson'])
