# https://git-scm.com/docs/git-init#_template_directory
# TODO: for each hook print a common header to explain why stuff
# is happening for the user.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  templateDir = "${config.xdg.dataHome}/git/templateDir";
  git = lib.getExe config.programs.git.package;
in
{
  # https://git-scm.com/docs/git-init#Documentation/git-init.txt-codeinittemplateDircode
  programs.git.extraConfig.init.templateDir = lib.mkDefault templateDir;

  # https://github.com/CompSciLauren/awesome-git-hooks
  xdg.dataFile = {
    # https://git-scm.com/docs/githooks#_post_checkout
    "git/templateDir/hooks/post-checkout" = {
      executable = true;
      source =
        pkgs.writers.writeFish "post-checkout"
          # fish
          ''
            # Check if the user has any stashes, which originates from this branch
            # If they do, then remind the user about them
            ${git} stash list

          '';
    };

    # inspiration: https://github.com/CompSciLauren/awesome-git-hooks/blob/master/pre-push-hooks/prevent-bad-push.hook
    # https://git-scm.com/docs/githooks#_pre_push
    "git/templateDir/hooks/pre-push" = {
      executable = true;
      source =
        pkgs.writers.writeFish "pre-push"
          # fish
          ''
            # Check all commits to be pushed:
            # 1. If it begins with `squash!` or `amend!` or `fixup!` then exit with an error
            #    and hint to user to do `git rebase --interactive <BASE>` where BASE is parent commit of the
            #    matching commits furthest back in the commit-chain.
            #    TODO: link to docs where these are explained
            # 2. If it begins with `WIP!` then exit with an error, and urge user to either
            #    - `git commit --amend` if its the HEAD commit
            #    - else suggest `git rebase --interactive <commit>^`
            #    This is a custom format that I use.

            set -l destination_name $argv[1]
            set -l destination_location $argv[2]

            echo "destination_name: $destination_name"
            echo "destination_location: $destination_location"

            # <local-ref> SP <local-object-name> SP <remote-ref> SP <remote-object-name> LF
            # refs/heads/master 67890 refs/heads/foreign 12345
            while read local_ref local_object_name remote_ref remote_object_name
              echo "local_ref: $local_ref"
              echo "local_object_name: $local_object_name"
              echo "remote_ref: $remote_ref"
              echo "remote_object_name: $remote_object_name"
            end

            # exit 1 # Prevent `git push` from completing
            exit 0 # Allow push
          '';
    };
    # TODO: prepare-commit-msg
    # https://github.com/CompSciLauren/awesome-git-hooks/blob/master/prepare-commit-msg-hooks/include-git-diff-name-status.hook
  };
}
