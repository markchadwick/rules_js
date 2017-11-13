
def _assert_is_ext(ext):
  if ext[0] != '.':
    fail("Extension %s doesn't start with a .", ext)

def _js_compiler_impl(ctx):

  # Ensure transformation extensions start with a period. ie -- A Javascript
  # extension should be `.js`, not `js`.
  for src_ext, dst_exts in ctx.attr.transform.items():
    _assert_is_ext(src_ext)
    for ext in dst_exts:
      _assert_is_ext(ext)

  runfiles = ctx.attr.compiler.default_runfiles\
    .merge(ctx.attr.compiler.data_runfiles)\
    .merge(ctx.runfiles(files=ctx.files.compiler))

  return struct(
    files     = depset(ctx.files.compiler),
    runfiles  = runfiles,
    compiler  = ctx.attr.compiler,
    transform = ctx.attr.transform,
    mnemonic  = ctx.attr.mnemonic,
    arguments = ctx.attr.arguments,
  )


js_compiler = rule(
  _js_compiler_impl,
  attrs = {
    'compiler': attr.label(
      doc        = 'Binary target used to compile to javascript',
      executable = True,
      cfg        = 'host'),

    'transform': attr.string_list_dict(
      doc = 'Declare the file transformations the compiler will make to the ' +
            'source files',
      mandatory = True),

    'mnemonic': attr.string(mandatory=True),

    'arguments': attr.string_list(),
  },
)
