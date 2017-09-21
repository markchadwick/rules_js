const fs = require('fs')

// const compileCjsx = require('coffee-react-transform')
const {compile}   = require('coffee-script')
const {promisify} = require('util')


function compileCs(csSrc) {
  return compile(csSrc)
}

// function compileCjsx(cjsxSrc) {
//   return compileCs(compileCjsx(cjsxSrc))
// }

function main(argv) {
  console.log('argv', argv)
  console.log('arguments', arguments)
}

process.exit(main.apply(this, process.argv.slice(1)))
