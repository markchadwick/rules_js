#!/usr/bin/env python
import argparse
import json
import os
import string
import sys
import tarfile

parser = argparse.ArgumentParser('Convert NPM tarballs into js_tar impls')
parser.add_argument('--buildfile')
parser.add_argument('--js_tar')
parser.add_argument('--npm_tar')
parser.add_argument('--types_tar')
parser.add_argument('--ts_def', nargs='*')


_BUILDFILE = string.Template("""
load('@io_bazel_rules_js//js/private:rules.bzl', 'js_tar')
# ${name}@${version}
${dep_comments}
js_tar(
  name   = 'lib',
  js_tar = '${output}',
  deps   = ${deps},
  visibility = ${visibility},
)
""")


def _extract_package(input):
  """
  In practice, it's not entirely safe to assume that all NPM packages have their
  package.json in a directory named "package". I have no goddamn clue (or
  interest in learning) how `npm` resolves with package.json in a tarball is the
  correct one, so y'all get this comment. If you've come across a bug which has
  lead you to this comment, my deepest sympathies.
  """
  member = input.getmember('package/package.json')
  return json.load(input.extractfile(member))


def _copy_tar_files(name, src, dst, filter=None):
  for member in src.getmembers():
    if filter and not filter(member):
      continue

    src_name = member.name
    dst_name = src_name.replace('package', name, 1)
    info = tarfile.TarInfo(dst_name)
    info.size = member.size
    dst.addfile(info, fileobj=src.extractfile(src_name))


def _write_buildfile(filename, package, js_tar_name, visibility=None):
  if visibility is None:
    visibility = ['//visibility:public']

  deps = []
  dep_comments = []
  for dep, ver in package.get('dependencies', {}).items():
    deps.append('@%s//:lib' % dep.replace('-', '.'))
    dep_comments.append('#  req: %s %s' % (dep, ver))

  with open(filename, 'w') as out:
    out.write(_BUILDFILE.substitute({
      'name':         package['name'],
      'version':      package.get('version', 'n/a'),
      'output':       os.path.basename(js_tar_name),
      'deps':         json.dumps(sorted(deps), indent=4),
      'dep_comments': '\n'.join(dep_comments),
      'visibility':   json.dumps(visibility),
    }))


def _main(buildfile, js_tar_name, npm_tar_name, types_tar_name, ts_defs):
  js_tar  = tarfile.open(js_tar_name, 'w:gz')
  npm_tar = tarfile.open(npm_tar_name)
  package = _extract_package(npm_tar)
  name    = package['name']

  # Copy source files over to the js_tar
  _copy_tar_files(name, npm_tar, js_tar)

  # If a types file is given, copy all .d.ts files overs
  if types_tar_name:
    types_tar = tarfile.open(types_tar_name)
    _copy_tar_files(name, types_tar, js_tar, lambda m: m.name.endswith('.d.ts'))

  # TODO: Copy ts_defs

  # Write the BUILD file
  _write_buildfile(buildfile, package, js_tar_name)


def _parse_args(args):
  params = parser.parse_args(args)

  if params.buildfile is None or \
     params.js_tar is None or \
     params.npm_tar is None:
    return None

  return params


def main(args):
  params = _parse_args(args[1:])
  if params is None:
    parser.print_help()
    return 2

  _main(
    buildfile      = params.buildfile,
    js_tar_name    = params.js_tar,
    npm_tar_name   = params.npm_tar,
    types_tar_name = params.types_tar,
    ts_defs        = params.ts_def,
  )

  return 0

if __name__ == '__main__':
  sys.exit(main(sys.argv))
