# TODO: checkout https://github.com/jhillyerd/plugin-git
# TODO: checkout https://github.com/franciscolourenco/done
# TODO: checkout https://github.com/oh-my-fish/plugin-grc
# TODO: checkout https://github.com/meaningful-ooo/sponge
{
  config,
  lib,
  pkgs,
  ...
}:
let
  github-plugins = import ./github-plugins.nix;
  # https://github.com/NixOS/nixpkgs/tree/f78c42dc1f2d51ea7263eae30a24fa60bdc95b5b/pkgs/shells/fish/plugins
  nixpkgs-plugins = [
    # "grc"
    "autopair"
    "done"
    "fishtape"
  ];
  scripts.update-plugin-hashes =
    pkgs.writers.writeFishBin "home-manager.fish.update-plugin-hashes" { }
      # fish
      ''
        ${builtins.toJSON github-plugins} | ${pkgs.jaq}/bin/jaq
          # ${pkgs.nurl}/bin/nurl
      '';

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
  scripts.plugins =
    pkgs.writers.writeNuBin "plugins" { } # nu
      ''
        # echo "github:"
        let github_plugins = ('${builtins.toJSON github-plugins}' | from json)
        $github_plugins
        | move owner repo --before hash
        | update repo {|row|
          let url = $"https://github.com/($row.owner)/($row.repo)"
          $url | ansi link --text $row.repo
        }
        | update hash {|row| $"(ansi d)($row.hash)(ansi reset)"}
        | update rev {|row| $"(ansi d)($row.rev)(ansi reset)"}


        # TODO: add subcommand check to see if a newer commit is available
        # $github_plugins
        # | par-each {|p| 
        # }

        # echo
        # echo "nixpkgs:"
        # '${builtins.toJSON nixpkgs-plugins}' | from json | insert {|row|}

        # https://github.com/NixOS/nixpkgs/blob/f78c42dc1f2d51ea7263eae30a24fa60bdc95b5b/pkgs/shells/fish/plugins/autopair.nix
      '';
in

{
  programs.fish.functions.plugins = lib.getExe scripts.plugins;

  programs.fish.plugins =
    (map fetch-from-github github-plugins)
    ++ (map (name: {
      inherit name;
      src = pkgs.fishPlugins.${name}.src;
    }) nixpkgs-plugins);
}
