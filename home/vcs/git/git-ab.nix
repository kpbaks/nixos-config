{ config, pkgs, ... }:
let
  git = "${config.programs.git.package}/bin/git";
  git-ab =
    pkgs.writers.writeFishBin "git-ab" { }
      # fish
      ''
        set -l remotes (${git} remote)
        if test (count $remotes) -eq 0
          echo "no remotes configured" >&2
          exit 2
        end
        set -l branch (${git} rev-parse --abbrev-ref --symbolic-full-name HEAD)
        set -l remote_branch (${git} rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
        if test $status -ne 0
          echo "local branch $branch not set to track any remote" >&2
          exit 2
        end

        # TODO: see which prefix of $remotes matches the $remote_branch name, or see if there is a builtin command for it
        set -l remote_of_remote_branch
        # origin/bugfix/disable-blame-history-popup-for-untracked-files

        # TODO: check last time updates were fetched from the remote. If it is beyond some threshold urge
        # user to fetch recent changes

        # TODO: estimate if there are a conflict that needs to be resolved if there are both ahead and behind

        set -l nc (set_color normal)
        set -l b (set_color --bold)
        set -l dim (set_color --dim)
        set -l green (set_color green)
        set -l red (set_color red)
        set -l yellow (set_color yellow)
        set -l blue (set_color blue)
        set -l magenta (set_color magenta --bold)

        set -l most_recent_common_ancestor (${git} merge-base $branch $remote_branch)
        set -l short_most_recent_common_ancestor (string sub --end=8 $most_recent_common_ancestor)

        set -l ahead_color $green
        set -l behind_color $red

        # TODO: use the configured colors under `git config color.branch.*`
        echo "branch: $branch"
        echo "remote_branch: $remote_branch"
        # TODO: print commit message of ancestor
        echo "most recent common ancestor: $short_most_recent_common_ancestor"
        echo
        set -l num_ahead 0
        set -l num_behind 0
        ${git} rev-list --left-right --pretty=oneline $branch...$remote_branch | while read line
          echo $line | string split --max 1 " " | read --line commit_part commit_msg
          set -l arrow (string sub --length=1 $commit_part)
          set -l commit_sha (string sub --start=2 $commit_part)
          set -l short_commit_sha (string sub --end=8 $commit_sha)
          # >232ad89a4dd8a85eb0eb0bc77c5ea064a51d2dd6 Bump two-face from 0.4.1 to 0.4.2 (#2500)

          set -l arrow_color
          if test $arrow = "<"
            set num_ahead (math $num_ahead + 1)
            set arrow_color $green
          else
            set num_behind (math $num_behind + 1)
            set arrow_color $red
            # $arrow = ">"
          end
          # TODO: check if known remote e.g. github, and add ansi link to the commit on github if behind
          printf "%s%s%s%s%s%s%s%s%s %s\n" $arrow_color $arrow $nc $magenta $short_commit_sha $nc $dim (string sub --start=8 $commit_sha) $nc $commit_msg
        end

        # TODO: print these before
        if test $num_ahead -eq 0
        else
          echo
          printf "ahead:  %s %s %s\n" (set_color -b green) $num_ahead $nc
          set_color --dim
          echo "HINT: to see diff of ahead"
          printf "\t"
          echo "git diff $short_most_recent_common_ancestor..$branch" | fish_indent --ansi
          set_color normal
        end
        if test $num_behind -eq 0
        else
          echo
          printf "behind: %s %s %s\n" (set_color -b red) $num_behind $nc
          set_color --dim
          echo "HINT: to see diff of behind"
          printf "\t"
          echo "git diff $short_most_recent_common_ancestor..$remote_branch" | fish_indent --ansi
          set_color normal
        end
      '';
in
{
  home.packages = [ git-ab ];

  programs.fish.shellAbbrs.gab = "git-ab";
}
