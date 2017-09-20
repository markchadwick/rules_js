
def _js_compiler_impl(ctx):
  src_ext = ctx.attr.src_ext

  # Ensure that input extensions start with a period. ie -- A Javascript
  # extension should be `.js`, not `js'.
  if src_ext[0] != '.':
    fail("src_ext '%s' doesn't start with .", src_ext)

  # runfiles = ctx.attr.compiler.default_runfiles\
  #   .merge(ctx.attr.compiler.data_runfiles)\
  #   .merge(ctx.runfiles(files=ctx.files.compiler))

  return struct(
    files    = depset(ctx.files.compiler),
    # runfiles = runfiles,
    compiler = ctx.attr.compiler,
    src_ext  = src_ext,
    mnemonic = ctx.attr.mnemonic,
  )


js_compiler = rule(
  _js_compiler_impl,
  attrs = {
    'compiler': attr.label(
      executable = True,
      cfg        = 'host',
    ),

    'src_ext':  attr.string(mandatory=True),
    'mnemonic': attr.string(mandatory=True),
  },
)
