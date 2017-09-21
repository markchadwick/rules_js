const compile = require('coffee-script').compile
const fs      = require('fs')
const path    = require('path')
const util    = require('util')


function promisify(fun) {
  return function() {
    let args = []
    for(let i=0; i<arguments.length; i++) {
      args.push(arguments[i])
    }
    return new Promise((resolve, reject) => {
      fun.apply(this, args.concat([(err, data) => {
        if (err) { reject(err) } else { resolve(data) }
      }]))
    })
  }
}

const readFile = promisify(fs.readFile)
const mkdirp   = promisify(require('mkdirp'))
const open     = promisify(fs.open)
const write    = promisify(fs.write)

function createWork(input, outDir) {
  const outFileName = path.basename(input).replace('.coffee', '.js')
  const srcRoot = path.dirname(input)
  const dstFile = path.join(outDir, outFileName)

  const outFile = mkdirp(srcRoot)
    .then(() => {
      return open(dstFile, 'w')
    })

  const jsSrc = readFile(input, 'utf8')
    .then((coffeeSrc) => {
      const opts  = {inlineMap: true, filename: input}
      return compile(coffeeSrc, opts)
    })

  return Promise.all([outFile, jsSrc]).then((vs) => {
    return write(vs[0], vs[1])
  })
}

function main(outDir, inputs) {
  let work = []
  for(let i=0; i < inputs.length; i++) {
    work.push(createWork(inputs[i], outDir))
  }

  Promise.all(work).then((vs) => {
    console.log('Good work!', vs)
  }).catch((e) => {
    console.log('Shitty work!', e)
    process.exit(2)
  })
}
const argv = process.argv
main(argv[2], argv.slice(3))
