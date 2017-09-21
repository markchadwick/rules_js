const fs          = require('fs')
const {expect}    = require('chai')
const {promisify} = require('util')

const cs = require('coffeescript/toolchain/coffeescript_compiler')


const mkdirp    = promisify(require('mkdirp'))
const readFile  = promisify(fs.readFile)
const readdir   = promisify(fs.readdir)
const writeFile = promisify(fs.writeFile)


describe('Coffeescript Compiler', () => {

  it('should compile .coffee files', () => {
    const js = cs.compile('test.coffee', '(n) -> n * 2', {bare: true})
    const fun = eval(js)

    expect(fun(333)).to.equal(666)
  })

  it('should compile .cjsx files', () => {
    const js = cs.compile('test.cjsx', '(n) -> n * 2', {bare: true})
    const fun = eval(js)

    expect(fun(333)).to.equal(666)
  })

  it('should compile cjsx', () => {
    const js = cs.compile('test.cjsx', 'x = <div style=666 />', {bare: true})
    const lines = js.split('\n')

    expect(lines[2]).to.equal('x = React.createElement("div", {')
    expect(lines[3]).to.equal('  "style": 666')
    expect(lines[4]).to.equal('});')
  })

  it('should not compile unknown files', () => {
    const haveAtIt = () => {
      cs.compile('test.js', 'function() { return false; }')
    }
    expect(haveAtIt).to.throw('Unknown file extension: .js')
  })


  describe('when compiling files', () => {

    beforeEach(async () => {
      await writeFile('./doubler.coffee', `
        module.exports = (n) -> n * 2
      `)
      await writeFile('./tripler.cjsx', `
        module.exports = (n) -> n * 3
      `)
    })

    it('should compile a file to a destination', async () => {
      await cs.compileFile('./doubler.coffee', './doubler.js', {bare: true})
      const js = await readFile('./doubler.js')
      const lines = js.toString().split('\n')
      expect(lines[0]).to.equal('module.exports = function(n) {')
      expect(lines[1]).to.equal('  return n * 2;')
      expect(lines[2]).to.equal('};')
    })

    it('should compile multiple files to a directory', async () => {
      await mkdirp('./out')
      await cs.main('./out', './doubler.coffee', './tripler.cjsx')

      const files = await readdir('./out')
      expect(files).to.contain('doubler.js')
      expect(files).to.contain('tripler.js')
    })
  })
})
