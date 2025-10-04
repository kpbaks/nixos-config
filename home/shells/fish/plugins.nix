# TODO: checkout https://github.com/jhillyerd/plugin-git
# TODO: checkout https://github.com/franciscolourenco/done
# TODO: checkout https://github.com/oh-my-fish/plugin-grc
# TODO: checkout https://github.com/meaningful-ooo/sponge
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # https://github.com/NixOS/nixpkgs/tree/f78c42dc1f2d51ea7263eae30a24fa60bdc95b5b/pkgs/shells/fish/plugins
  nixpkgs-plugins =
    map
      (name: {
        inherit name;
        src = pkgs.fishPlugins.${name}.src;
      })
      [
        # "grc"
        "autopair"
        "bass"
        "done"
        "fishtape"
      ];

  fetch-from-github =
    {
      owner,
      repo,
      rev,
      hash,
    }:
    {
      name = repo;
      src = pkgs.fetchFromGitHub {
        inherit
          owner
          repo
          rev
          hash
          ;
      };
    };
  # scripts.plugins =
  #   pkgs.writers.writeNuBin "plugins" { } # nu
  #     ''
  #       # echo "github:"
  #       # TODO: make revs be a hyperlink to the repo at the commit
  #       let github_plugins = ('${builtins.toJSON github-plugins}' | from json)

  #       $github_plugins
  #       | move owner repo rev --before hash
  #       | update repo {|row|
  #         let url = $"https://github.com/($row.owner)/($row.repo)"
  #         $url | ansi link --text $row.repo
  #       }
  #       | update hash {|row| $"(ansi d)($row.hash)(ansi reset)"}
  #       | update rev {|row|
  #         let commit = ($row.rev | str substring 0..6)
  #         let rest = ($row.rev | str substring 7..)
  #         $"(ansi blue)($commit)(ansi reset)(ansi d)($rest)(ansi reset)"
  #         # $"(ansi d)($row.rev)(ansi reset)"
  #       }
  #       | sort-by repo

  #       # TODO: add subcommand check to see if a newer commit is available
  #       # $github_plugins
  #       # | par-each {|p|
  #       # }

  #       # http get https://api.github.com/repos/kpbaks/zellij.fish/commits?per_page=1 | get 0.sha

  #       # TODO: use url build-query

  #       # echo
  #       # echo "nixpkgs:"
  #       # '${builtins.toJSON nixpkgs-plugins}' | from json | insert {|row|}

  #       # https://github.com/NixOS/nixpkgs/blob/f78c42dc1f2d51ea7263eae30a24fa60bdc95b5b/pkgs/shells/fish/plugins/autopair.nix
  #     '';
in

{
  # programs.fish.functions.plugins = lib.getExe scripts.plugins;
  programs.fish.plugins = nixpkgs-plugins ++ [
    # {
    #   name = "git.fish";
    #   src = inputs.git_fish;
    # }
    {
      name = "ctrl-z.fish";
      src = inputs.ctrl_z_fish;
    }
    # {
    #   name = "nix.fish";
    #   src = inputs.nix_fish;
    # }
    {
      name = "private_mode.fish";
      src = inputs.private_mode_fish;
    }
    {
      name = "nix_command_not_found.fish";
      src = inputs.nix_command_not_found_fish;
    }
  ];

  # programs.fish.plugins =
  #   (map fetch-from-github github-plugins)
  #   ++ (map (name: {
  #     inherit name;
  #     src = pkgs.fishPlugins.${name}.src;
  #   }) nixpkgs-plugins);
}
