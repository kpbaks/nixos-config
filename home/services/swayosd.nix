{ config, pkgs, ... }:
{

  # TODO: use
  # https://github.com/ErikReider/SwayOSD/blob/11271760052c4a4a4057f2d287944d74e8fbdb58/data/style/style.scss
  xdg.configFile."swayosd/style.css".text =
    with config.flavor;
    # css
    ''
      window#osd {
        padding: 12px 20px;
        border-radius: 999px;
        border: none;
        background: alpha(${crust.hex}, 0.8);
      }

      #container {
        margin: 16px;
      }

      image, label {
        color: ${teal.hex};
      }

      progressbar:disabled,
      image:disabled {
        opacity: 0.5;
      }

      progressbar {
        min-height: 6px;
        border-radius: 10%;
        background: transparent;
        border: none;
      }

      trough {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: alpha(${mauve.hex}, 0.5);
      }

      progress {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: ${mauve.hex};
      }
    '';
  services.swayosd = {
    enable = false;
    topMargin = 0.5; # center
    # display = monitors.laptop;
    display = "eDP-1";
    stylePath = "${config.xdg.configHome}/swayosd/style.css";
  };

  home.packages = [ pkgs.swayosd ];
}
