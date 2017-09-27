#!/usr/bin/env python
from __future__ import print_function

import json
import os
import sys
import tarfile


def _bazel_name(npm_name):
  return npm_name\
    .replace('-', '.')\
    .replace('/', '_')\
    .replace('@', '_')


def _js_library_buildfile(name, srcs, deps, package=None):
  label_list = lambda a: json.dumps(a, indent=4)
  if package is not None:
    package = json.dumps(package)

  return """load("@com_vistarmedia_rules_js//js:def.bzl", "js_library")
js_library(
  name="{name}",
  srcs={srcs},
  deps={deps},
  package={package},
  visibility=["//visibility:public"], # TODO
)
  """.format(
    name = name,
    srcs = label_list(srcs),
    deps = label_list(deps),
    package = package,
  )


class Workspace(object):
  def __init__(self, name, root, ignore_deps):
    self._name = name
    self._root = root
    self._packages = []

    self._ignore_deps = [_bazel_name(dep) for dep in ignore_deps]

  def package(self, cfg):
    npm_name   = cfg['name']
    bazel_name = _bazel_name(npm_name)

    package_root = os.path.join(self._root, bazel_name)
    package = Package(package_root, cfg, npm_name, bazel_name)
    self._packages.append(package)
    return package

  def create(self):
    for package in self._packages:
      self._create_package(package)

    self._create_buildfile()

  def _create_buildfile(self):
    deps = [self._package_name(p) for p in self._packages]

    build_root = os.path.join(self._root, 'BUILD')
    with open(build_root, 'w') as build:
      build.write(_js_library_buildfile(
        name = 'lib',
        srcs = [],
        deps = deps,
      ))

  def _create_package(self, package):
    build_path = os.path.join(package.root, 'BUILD')
    with open(build_path, 'w') as out:
      out.write(package.buildfile(self._ignore_deps))

  def _package_name(self, package):
    return '@%s//%s' % (self._name, package._bazel_name)


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

  def buildfile(self, ignore_deps):
    deps = []

    for dep, _ in self._cfg.get('dependencies', {}).items():
      name = _bazel_name(dep)

      if name in ignore_deps:
        continue

      target = '@%s//%s' % (name, name)
      deps.append(target)

    return _js_library_buildfile(
      name    = self._bazel_name,
      package = self._npm_name,
      srcs    = self._files,
      deps    = deps,
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


def _install_tarball(workspace, tarball):
  src = tarball['src']

  with tarfile.open(src) as tarball:
    for root, cfg in _tarball_packages(tarball):
      package = workspace.package(cfg)

      for src in tarball.getmembers():
        if not src.isfile(): continue
        if not src.path.startswith(root): continue

        name = os.path.relpath(src.path, root)
        package.add_file(name, tarball.extractfile(src).read())


def main(name, root, deps, ignore_deps):
  workspace = Workspace(name, root, ignore_deps)
  for dep in deps:
    if dep['type'] == 'tarball':
      _install_tarball(workspace, dep)

    else:
      raise Exception('Unknown type: %s' % type)

  workspace.create()
  from random import randint
  print('ok!', randint(0, 666))

if __name__ == '__main__':
  sys.stdout = open('/tmp/stdout', 'w')
  sys.stderr = open('/tmp/stderr', 'w')
  args = json.loads(sys.argv[1])
  sys.exit(main(**args))
