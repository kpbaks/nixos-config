# TODO: use a cargo-script
# https://crates.io/crates/semver
# check if git-cliff is supported
# - check if `git-cliff` is installed
# - check if `cliff.toml` exists in repo
# check if CHANGELOG.md exists
# check for known project files like Cargo.toml and pyproject.toml and VERSION
# accept one of "major" "minor" "patch" as argument
# compute the new semver and apply all the updates from the targets available
# check in a git repo
# check that git workspace is not dirty, fail if it is
# 1. create empty commit with `git commit --allow-empty --no-edit --no-verify`
# 2. do `git tag <new-semver>`
# 2. get current semver version, or create first one if no is found e.g. `v0.1.0`
# 3. apply new version to all project files
# 4. do `git-cliff -o CHANGELOG.md`
# 5. `git commit --amend --no-edit` # NOTE: do not pass --no-verify here, to allow the users pre-commit hook to agree with our changes
{
  config,
  lib,
  pkgs,
  ...
}:

let
  git-cliff = lib.getExe config.programs.git-cliff.package;
  # version-bump = pkgs.writers.writeFishBin "version-bump" { } '''';
  version-bump = pkgs.writers.writePython3Bin "version-bump" { } ''
    import sys
    import subprocess
    import os
    import shutil
    import argparse

    print(f"{sys.version_info=}")
  '';
in
{
  home.packages = [ version-bump ];
}
