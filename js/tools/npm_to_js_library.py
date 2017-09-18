#!/usr/bin/env python
from __future__ import print_function

import json
import os
import sys
import tarfile


def _bazel_name(npm_name):
  return npm_name\
    .replace('-', '.')


class Workspace(object):
  def __init__(self, root):
    self._root = root
    self._packages = []

  def package(self, cfg):
    npm_name   = cfg['name']
    bazel_name = _bazel_name(npm_name)

    package_root = os.path.join(self._root, npm_name)
    package = Package(package_root, cfg, npm_name, bazel_name)
    self._packages.append(package)
    return package

  def create(self):
    for package in self._packages:
      self._create_package(package)

  def _create_package(self, package):
    build_path = os.path.join(package.root, 'BUILD')
    with open(build_path, 'w') as out:
      out.write(package.buildfile())


class Package(object):

  def __init__(self, root, cfg, npm_name, bazel_name):
    self.root        = root
    self._cfg        = cfg
    self._npm_name   = npm_name
    self._bazel_name = bazel_name
    self._files      = []

  def add_file(self, name, f):
    abspath = os.path.join(self.root, name)
    dirname = os.path.dirname(abspath)

    if not os.path.isdir(dirname):
      os.makedirs(dirname)

    with open(abspath, 'w') as out:
      out.write(f)

    self._files.append(name)

  def buildfile(self):
    return '\n'.join([
      'load("@com_vistarmedia_rules_js//js:def.bzl", "js_library")',
      'js_library(',
      '  name = "{bazel_name}",',
      '  package = "{npm_name}",',
      '  srcs = {srcs},',
      '  visibility = ["//visibility:public"],', # TODO
      ')',
    ]).format(
      npm_name   = self._npm_name,
      bazel_name = self._bazel_name,
      srcs       = json.dumps(self._files, indent=2),
    )


def _tarball_packages(src):
  """
  This considers each directory with a `package.json` a tarball package. For
  each such directory encountered, yield its root along with its deserialized
  `package.json` contents.
  """
  for member in src.getmembers():
    if not member.isfile(): continue
    name = member.name

    # Do not look in nested node_modules directories for dependencies
    if '/node_modules/' in name:
      continue

    if os.path.basename(name) == 'package.json':
      root    = os.path.dirname(name)
      package = json.load(src.extractfile(member))
      yield root, package


def tarball(root, src):
  workspace = Workspace(root)

  with tarfile.open(src) as tarball:
    for root, cfg in _tarball_packages(tarball):
      package = workspace.package(cfg)

      for src in tarball.getmembers():
        if not src.isfile(): continue
        if not src.path.startswith(root): continue

        name = os.path.relpath(src.path, root)
        package.add_file(name, tarball.extractfile(src).read())

  workspace.create()
  print('OK!')


def main(type, **kwargs):
  if type == 'tarball':
    return tarball(**kwargs)

  raise Exception('Unknown type: %s' % type)

if __name__ == '__main__':
  sys.stdout = open('/tmp/stdout', 'w')
  sys.stderr = open('/tmp/stderr', 'w')
  args = json.loads(sys.argv[1])
  sys.exit(main(**args))
