const http   = require('http')
const crypto = require('crypto')


function getSha256(httpsUrl, callback) {
  const url = httpsUrl.replace('https:', 'http:')

  http.request(url, (resp) => {
    const hash = crypto.createHash('sha256')
    resp.on('data', (chunk) => hash.update(chunk))
    resp.on('end', () => callback(hash.digest('hex')))
  }).end()
}

function handleNpmResponse(pkg) {
  const name    = pkg['name']
  const version = pkg['dist-tags']['latest']
  const tarball = pkg['versions'][version]['dist']['tarball']

  let deps = pkg['versions'][version]['dependencies']
  if(deps) {
    deps = Object.keys(deps)
  }

  getSha256(tarball, (sha256) => {
    console.log('npm_install(')
    console.log(`  name = '${name}',`)
    console.log(`  version = '${version}',`)
    console.log(`  sha256 = '${sha256}',`)

    if(deps) {
      console.log(`  ignore_deps = ${JSON.stringify(deps).replace(/\"/g, "'")}`)
    }
    console.log(')')
  })
}

function main(pkg) {
  const options = {
    host: 'registry.npmjs.org',
    path: `/${pkg}/`
  }
  http.request(options, (resp) => {
    let content = ''
    resp.on('data', (chunk) => content += chunk)
    resp.on('end', () => handleNpmResponse(JSON.parse(content)))
  }).end()
}
main(process.argv[2])
