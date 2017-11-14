const ts = require('typescript')

function logError(error) {
  const {
    code,
    file,
    length,
    messageText,
    start,
  } = error


  if(!file) {
    console.error(error)
    return
  }
  const {fileName, text, lineMap} = file

  const {line, character} = error.file.getLineAndCharacterOfPosition(start)
  const lineContent = text.split('\n')[line]

  console.error()
  console.error('[ERROR TS%s] %s %s:%s ', code,
    fileName, line+1, character+1,
    messageText)
  console.error(lineContent)
  console.error(' '.repeat(character) + '^')
}

function exitErrors(errors) {
  errors.forEach(logError)
  process.exit(1)
}

function compile(config, out, srcs) {
  let args = [
    '--outDir', out,
    '--rootDir', '.',
    '--noEmitOnError',
  ]

  if(!!config.arguments) {
    args = args.concat(config.arguments)
  }

  const cmd = ts.parseCommandLine(args.concat(srcs))
  const program = ts.createProgram(cmd.fileNames, cmd.options)
  const {emitSkipped, diagnostics} = program.emit()

  if(emitSkipped) {
    exitErrors(diagnostics)
  }
}


const fs = require('fs')
const path = require('path')
function _walk(dir, done) {
  // console.log('WALK IT')
  fs.readdir(dir, function(err, files) {
    if (err) throw err;
    files.forEach(function(file) {
      var filePath = path.join(dir, file)
      fs.stat(filePath, function(err, stats) {
        if (err) throw err;
        if(stats.isDirectory()) {
          console.log('d', filePath)
          _walk(filePath)
        } else {
          if(filePath.endsWith('.js') || filePath.endsWith('.d.ts')) {
            console.log('f', filePath)
          }
        }
      })
    })
  })
}

/**
 * Typescript Compiler entrypoint. Due to the way the js_compiler system is
 * setup, there are two ways to use this binary. In all examples, argument
 * position and calling pattern matters.
 *
 * Simplified usage -- what you'll get without creating a `cfg` argument in the
 * `typescript_compiler` rule:
 *
 *    node tsc.js output/dir src1.ts src2.ts src3.ts
 *
 * Full usage -- when you create a custom compiler
 *
 *    node tsc.js --config {"some": "options"} output/dir src1.ts src2.ts
 */
function main(args) {
  let config = {}

  // If a config is given, parse it, and shift the arguments accordingly
  if(args[0] === '--config') {
    config = JSON.parse(args[1])
    args = args.slice(2)
  }

  const out  = args[0]
  const srcs = args.slice(1)

  console.log('-------------------------------------------------')
  _walk('.')
  setTimeout(function() { compile(config, out, srcs) }, 1000)
}

main(process.argv.slice(2))
