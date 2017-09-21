const fs   = require('fs')
const path = require('path')

const compileCjsx = require('coffee-react-transform')
const compileCoffee = require('coffee-script').compile
const {promisify}   = require('util')

const readFile = promisify(fs.readFile)
const writeFile = promisify(fs.writeFile)


function compile(filename, src, opts={}) {
  const ext = path.extname(filename)
  const compileOpts = {filename: filename, ...opts}

  switch(ext) {
    case '.coffee':
      return compileCoffee(src, compileOpts)

    case '.cjsx':
      return compileCoffee(compileCjsx(src), compileOpts)

    default:
      throw new Error(`Unknown file extension: ${ext}`)
  }

}
module.exports.compile = compile


async function compileFile(srcFilename, dstFilename, opts={}) {
  const coffeeSrc = await readFile(srcFilename, 'utf8')
  const jsSrc = compile(srcFilename, coffeeSrc, opts)
  return writeFile(dstFilename, jsSrc)
}
module.exports.compileFile = compileFile

function compileAll(outdir, srcs) {
  let work = []

  for(let i=0; i<srcs.length; i++) {
    const src = srcs[i]
    const basename = path.basename(src)
    const dirname  = path.dirname(src)
    const ext      = path.extname(basename)

    let outName = ''
    switch(ext) {
      case '.coffee':
      case '.cjsx':
        outName = basename.replace(ext, '.js')
        break

      default:
        throw new Error(`Unknown file extension: ${ext}`)
    }

    const dstFilename = path.join(outdir, dirname, outName)
    work.push(compileFile(src, dstFilename))
  }

  return Promise.all(work)
}

async function main(outdir, ...srcs) {
  await compileAll(outdir, srcs)
  return 0
}
module.exports.main = main

if (require.main === module) {
  main.apply(this, process.argv.slice(1))
    .then(process.exit)
    .end()
}
