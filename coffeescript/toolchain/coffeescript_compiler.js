const fs   = require('fs')
const path = require('path')

const compileCjsx = require('coffee-react-transform')
const compileCoffee = require('coffee-script').compile
const {promisify}   = require('util')

const readFile = promisify(fs.readFile)
const writeFile = promisify(fs.writeFile)


function badFileExtension(name) {
  throw new Error(`File '${name}' has bad extension, '${path.extname(name)}'.`)
}

function compile(filename, src, opts) {
  const ext = path.extname(filename)
  const compileOpts = {filename: filename, ...opts}

  switch(true) {
    case ext === '.cjsx':
    case opts.always_compile_cjsx:
      return compileCoffee(compileCjsx(src), compileOpts)

    case ext === '.coffee':
      return compileCoffee(src, compileOpts)

    default:
      badFileExtension(filename)
  }

}
module.exports.compile = compile


async function compileFile(srcFilename, dstFilename, opts) {
  const coffeeSrc = await readFile(srcFilename, 'utf8')
  const jsSrc = compile(srcFilename, coffeeSrc, opts)
  return writeFile(dstFilename, jsSrc)
}
module.exports.compileFile = compileFile

function compileAll(outdir, srcs, opts) {
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
        badFileExtension(src)
    }

    const dstFilename = path.join(outdir, dirname, outName)
    work.push(compileFile(src, dstFilename, opts))
  }

  return Promise.all(work)
}

async function main(argv) {
  let opts = {}
  let outdir = null
  let srcs = []

  for(let i=0; i<argv.length; i++) {
    const arg = argv[i]

    if(arg.startsWith('--')) {
      opts[arg.substring(2)] = true
    } else if(outdir === null) {
      outdir = arg
    } else {
      srcs.push(arg)
    }
  }

  await compileAll(outdir, srcs, opts)
  return 0
}
module.exports.main = main

if (require.main === module) {
  main(process.argv.slice(2))
    .then(process.exit)
    .catch((err) => {
      console.error(err)
      process.exit(1)
    })
}
