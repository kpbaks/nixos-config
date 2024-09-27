{
  config,
  inputs,
  pkgs,
  ...
}:
let

  # TODO: improve
  scripts.spotify-cover-art =
    pkgs.writers.writeFishBin "spotify-cover-art" { }
      # fish
      ''
        set -l cdn (${pkgs.playerctl}/bin/playerctl -p spotify metadata mpris:artUrl)
        if test -z $cdn
          # spotify not running
          exit
        end
        set -l cover /tmp/cover.jpeg
        ${pkgs.curl}/bin/curl --silent "$cdn" --output $cover
        echo $cover
        # if isatty stdout
        #   ${pkgs.timg}/bin/timg --center $cover
        # else
        #   echo $cover
        # end
      '';
in

{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.packages =
    builtins.attrValues scripts
    ++ (with pkgs; [
      spotify-tray
      spotify-cli-linux
    ]);

  programs.spotify-player.enable = false;
  services.spotifyd.enable = false;

  # TODO: override the spotify package used by spicetify to add a proper icon
  programs.spicetify =
    let
      spicetify-pkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      enabledExtensions = with spicetify-pkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
        autoVolume
        betterGenres
        powerBar
      ];
      enabledCustomApps = with spicetify-pkgs.apps; [
        # reddit
        newReleases
      ];
      # theme = spicetify-pkgs.themes.fluent;
      theme = spicetify-pkgs.themes.catppuccin;
      colorScheme = config.catppuccin.flavor;
      # colorScheme = "macchiato";
    };
}
