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

  git-install-global-templatedir-hooks =
    pkgs.writers.writeFishBin "git-install-global-templatedir-hooks" { }
      # fish
      ''
        ${git} rev-parse --show-toplevel 2> /dev/null | read toplevel
        if test $pipestatus[1] -ne 0
          printf "%serror%s: not inside a git repository\n" (set_color red --bold) (set_color normal) >&2
          exit 1
        end

        if argparse f/force -- $argv
          exit 2
        end

        for hook in ${templateDir}/hooks/*
          set -l git_event (path basename $hook)
          if test $toplevel/.git/hooks/$git_event; and not set -q _flag_force
           echo "skipping ..."
           continue
          end

          cp $hook $toplevel/.git/hooks/$git_event
          # TODO: print ansi link to git docs
          echo "installed $git_event hook"
        end
      '';
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
            # - Check if this branch is behind its merge-base, and hint to the user to do a rebase
            # - Check if this branch has a remote, and let the user know of it
            # - Check if the user has any stashes, which originates from this branch
            #   If they do, then remind the user about them
            ${git} stash list

          '';
    };

    # IDEA: turn into a rust program
    # in rust program assert that $args[0] is .git/hooks/pre-push
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

            # TODO: check for new tags, that are to be pushed. if any of them match a semver version
            # tag, then check if the commit they are pointing to also contains a diff of a "known" project file e.g.
            # pyproject.toml or Cargo.toml, and check the version written in that file and commit, to see if it matches.
            # At times I forget to update the project file, when I do a new tag

            # exit 1 # Prevent `git push` from completing
            exit 0 # Allow push
          '';
    };
    # TODO: prepare-commit-msg
    # https://github.com/CompSciLauren/awesome-git-hooks/blob/master/prepare-commit-msg-hooks/include-git-diff-name-status.hook
  };

  home.packages = [ git-install-global-templatedir-hooks ];
}
