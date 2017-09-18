workspace(name='com_vistarmedia_rules_js')

load('//js:def.bzl', 'js_repositories')
js_repositories()

# npm_tarball_install(
#   name = 'ajax',
#   url = 'https://s3.amazonaws.com/js.vistarmedia.com/ajax-3bc385.tar.gz',
#   sha256 = '58954b2f7c298d0c13085ef76ad5702dc4a3f79eac5f64da9a78fd2c9237c2fe',
# )

load('//js/private:npm_install.bzl', 'npm_install')
npm_install('lodash', version='4.2.1')
