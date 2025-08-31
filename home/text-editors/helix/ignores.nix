{
  programs.helix.ignores = [
    "target/"
    "build/"
    ".direnv/"

    "!.helix/"
    "!.gitlab-ci.yml"
    "!.github/"
    "!.gitignore"
    "!.git-blame-ignore-revs"
    "!.gitattributes"
    "!.gitmodules"
    "!.mailmap"
    "!.typos.toml"
    "!.editorconfig"
    # "!.git/"
    "!.git/gitui"
    "!.git/hooks/"
    "!.devcontainer/"
    ".git/objects"
  ];
}
