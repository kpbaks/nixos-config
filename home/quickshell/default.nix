# https://quickshell.outfoxxed.me/
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # https://github.com/nix-community/nixGL#usage
  # FIXME: make it work without this fix
  # noctalia-shell = pkgs.writeShellScriptBin "noctalia-shell" ''
  #   ${lib.getExe pkgs.nixgl.nixGLIntel} ${lib.getExe inputs.noctalia.packages.${pkgs.system}.default}
  # '';
  noctalia-shell = inputs.noctalia.packages.${pkgs.system}.default;
in
{
  # FIXME: why are these not in $PATH $out/bin/{qs,quickshell}
  home.packages = [
    inputs.quickshell.packages.${pkgs.system}.default
    # (inputs.quickshell.packages.${pkgs.system}.default.override {
    #   withJemalloc = true;
    #   withQtSvg = true;
    #   withWayland = true;
    #   withX11 = false;
    #   withPipewire = true;
    #   withPam = true;
    #   withHyprland = false;
    # })

    pkgs.kdePackages.qtdeclarative # for `qmlformat`, `qmllint`, `qmlls`
    noctalia-shell
  ];

  # https://github.com/noctalia-dev/noctalia-shell#recommended-compositor-settings
  programs.niri = {
    settings = {
      debug = {
        # FIXME: github:sodiboo/niri-flake does not have support for this option
        # honor-xdg-activation-with-invalid-serial = true;
      };

      window-rules = [
        {
          geometry-corner-radius =
            let
              r = 20.0;
            in
            {
              bottom-right = r;
              bottom-left = r;
              top-right = r;
              top-left = r;
            };
          clip-to-geometry = true;
        }
      ];

      layer-rules = [
        {
          matches = [
            {
              namespace = "^quickshell-wallpaper$";
            }
          ];
        }
        {
          matches = [
            {
              namespace = "^quickshell-overview$";

            }
          ];
          place-within-backdrop = true;
        }
      ];
      binds = with config.lib.niri.actions; {
        "Mod+Slash" = {
          action = spawn (lib.getExe noctalia-shell) "ipc" "call" "launcher" "toggle";
          hotkey-overlay.title = "Toggle Application Launcher";
          repeat = false;
        };
      };

      # "Mod+Slash" =
      #   let
      #     fuzzel = "${config.programs.fuzzel.package}/bin/fuzzel";
      #     pkill = "${pkgs.procps}/bin/pkill";
      #   in
      #   {
      #     # Hit "Mod+Slash" again to hide/close fuzzel again
      #     action = sh "${pkill} fuzzel || ${fuzzel}";
      #     hotkey-overlay.title = "Toggle fuzzel (App launcher and fuzzy finder)";
      #     repeat = false;
      #   };
      spawn-at-startup = [
        {
          # map (s: { command = pkgs.lib.strings.splitString " " s; })
          command = [ (lib.getExe noctalia-shell) ];
        }
      ];
    };
  };
}
