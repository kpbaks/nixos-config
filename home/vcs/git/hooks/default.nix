{
  config,
  lib,
  pkgs,
  ...
}:
let
  # prepare-commit-msg = pkgs.writeShellApplication {
  #   name = "prepare-commit-msg";
  #   runtimeInputs = [
  #     config.programs.git.package
  #     # pkgs.yq-go
  #     # pkgs.jq
  #   ];
  #   # This script is called by `git commit` after commit message was initialized and right before
  #   # an editor is launched.
  #   #
  #   # It receives one to three arguments:
  #   #
  #   # $1 - the path to the file containing the commit message. It can be edited to change the message.
  #   # $2 - the kind of source of the message contained in $1. Possible values are
  #   #      "message" - a message was provided via `-m` or `-F`
  #   #      "commit" - `-c`, `-C` or `--amend` was given
  #   #      "squash" - the `.git/SQUASH_MSG` file exists
  #   #      "merge" - this is a merge or the `.git/MERGE` file exists
  #   #      "template" - `-t` was provided or `commit.template` was set
  #   # $3 - If $2 is "commit" then this is the hash of the commit.
  #   #      It can also take other values, best understood by studying the source code at
  #   #      https://github.com/git/git/blob/aa9166bcc0ba654fc21f198a30647ec087f733ed/builtin/commit.c#L745
  #   text = ''
  #     readonly COMMIT_MSG_FILE=$1
  #     readonly BRANCH_NAME=$(git symbolic-ref --short HEAD)
  #     readonly COMMIT_MSG_TYPE=$2
  #     readonly COMMIT_HASH=$3

  #     readonly branch="$(git branch --show-current | tr -d '\n')"
  #     # Next, we let Git parse any trailers from the branch description as a new line delimited string.
  #     # Use of (|| :) is a no operation to prevent premature Git hook abortion should the command fail.
  #     readonly trailers="$(git config --get "branch.$branch.description" | git interpret-trailers --parse || :)"
  #     # get branch description and copy trailers from it
  #     # git config --get branch.demo.description

  #     if [[ -f .gitlab/changelog_config.yml ]]; then
  #       # https://docs.gitlab.com/user/project/changelogs/#customize-the-changelog-output
  #     fi

  #     case "$COMMIT_MSG_TYPE"; do
  #       message)
  #           printf "\n\n%s" "$trailers" >> "$commit_message_path";;
  #       commit)
  #       squash)
  #       merge)
  #       template)
  #     esac

  #   '';

  # };

  # This script is called by `git commit` after commit message was initialized and right before
  # an editor is launched.
  #
  # It receives one to three arguments:
  #
  # $1 - the path to the file containing the commit message. It can be edited to change the message.
  # $2 - the kind of source of the message contained in $1. Possible values are
  #      "message" - a message was provided via `-m` or `-F`
  #      "commit" - `-c`, `-C` or `--amend` was given
  #      "squash" - the `.git/SQUASH_MSG` file exists
  #      "merge" - this is a merge or the `.git/MERGE` file exists
  #      "template" - `-t` was provided or `commit.template` was set
  # $3 - If $2 is "commit" then this is the hash of the commit.
  #      It can also take other values, best understood by studying the source code at
  #      https://github.com/git/git/blob/aa9166bcc0ba654fc21f198a30647ec087f733ed/builtin/commit.c#L745
  prepare-commit-msg = pkgs.writers.writeNuBin "prepare-commit-msg" { } ''
    def main [
      commit_msg_file: string
      commit_msg_type: string
      # FIXME: this generates a syntax error
      # should be caught by `nu-check`
      commit_hash: string?
    ] {

      if (".gitlab/changelog_config.yml" | path exists) {
        # https://docs.gitlab.com/user/project/changelogs/#customize-the-changelog-output
      }

      # echo "# https://docs.gitlab.com/user/project/changelogs/#add-a-trailer-to-a-git-commit" >> $COMMIT_MSG_FILE
      # echo "# One of: added | fixed | changed | deprecated | removed | security | performance | other"
      # echo "Changelog: added" >> $COMMIT_MSG_FILE
      # echo "Tracker: jira"
      # echo "Tracker: jira.beumer.com"
      # # echo "Reviewer: github"
      # echo "Issue: #DATA-6000"
      # echo "Milestone:"
      # echo "Format: markdown"
      let branch = ^git branch --show-current
      let branch_trailers: record<string, string> = ^git config --get $"branch.($branch).description"
      | ^git interpret-trailers --parse
      | parse "{key}: {value}"
      | each { {$in.key: $in.value} }
      | reduce --fold {} {|it, acc| $acc | merge $it }

      match $commit_msg_type {
        "message" => {
          mut trailers: record = $branch_trailers
          $trailers.Format = "markdown"

          let remotes: table<remote: string, url: string> = ^git config --get-regexp 'remote\..+\.url' | parse "remote.{remote}.url {url}"
          match $remotes {
            [{url: $url}] => {
              try {
                let host: string = $url | url parse | get host
                # remove tld e.g. .com or .org
                let host_without_tld = $host | str replace --regex '\.[^.]$' ""
                $trailers.Reviewer = $host_without_tld
              }
            }
          }

          let trailers: string = $trailers | items {|key, value| $"($key): ($value)"} | str join "\n"
          "\n\n" o>> $commit_msg_file
          "# https://docs.gitlab.com/user/project/changelogs/#add-a-trailer-to-a-git-commit" o>> $commit_msg_file
          "# One of: added | fixed | changed | deprecated | removed | security | performance | other" o>> $commit_msg_file
          "Changelog: added" o>> $commit_msg_file
          $trailers o>> $commit_msg_file
        }
        "template" => {

        }
        "squash" => {}
        "merge" => {}
        "commit" => {}
        # _ => {}
      }
    }
  '';
in
{
  programs.git.hooks = {
    # Design motivated by this article: https://www.alchemists.io/articles/git_trailers
    # prepare-commit-msg = lib.getExe prepare-commit-msg;

    # TODO: create hook disable direnv when moving to branches where `flake.lock` differs from the one moved from
    # to not needlessly having to rebuild when during a simple checkout
    # also run `git log` to show the git commit on it, not push to remote or not on parent/main/default branch
    # run `git show`
    # https://frankcorso.dev/automatically-run-build-scripts-switching-branches-git-hooks.html
    # post-checkout = lib.getExe post-checkout;
  };
}
