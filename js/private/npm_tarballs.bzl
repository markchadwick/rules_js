

def _npm_tarballs_impl(ctx):
  names, urls, sha256s = ctx.attr.names, ctx.attr.urls, ctx.attr.sha256s

  # Note: Bazel doesn't allow A == B == C syntax
  if not (len(names) == len(urls) and len(urls) == len(sha256s)):
    fail('mismatched argument length for `npm_tarballs`')

  for name, url, sha256 in zip(names, urls, sha256s):
    print(name, url, sha256)


npm_tarballs = repository_rule(
  _npm_tarballs_impl,
  attrs = {
    'names':    attr.string_list(),
    'urls':     attr.string_list(),
    'sha256s':  attr.string_list(),
  },
)
