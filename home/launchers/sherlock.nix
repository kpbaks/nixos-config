{ config, pkgs, ... }:
{
  programs.sherlock = {
    enable = true;
    systemd.enable = true;

    aliases = {
      "NixOS Wiki" = {
        exec = "firefox https://nixos.wiki/index.php?search=%s";
        icon = "nixos";
        keywords = "nix wiki docs";
        name = "NixOS Wiki";
      };
    };
    ignore = ''
      Avahi*
    '';
    # settings = null;
    # settings = {
    #   theme = "dark";
    # };

    aliases = {
      vesktop = {
        name = "Discord";
      };
    };

    # fallback.json
    launchers = [
      {
        name = "Calculator";
        type = "calculation";
        args = {
          capabilities = [
            "calc.math"
            "calc.units"
          ];
        };
        priority = 1;
      }
      {
        name = "App Launcher";
        type = "app_launcher";
        args = { };
        priority = 2;
        home = "Home";
      }
    ];

    # main.css
    style = # css
      ''
        * {
          font-family: sans-serif;
        }
      '';
  };
}
