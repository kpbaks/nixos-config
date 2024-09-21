{ pkgs, ... }:
{
  services.dunst = {
    enable = false;
    # catppuccin.enable = false;
    settings = {
      global = {
        width = "(200,300)";
        height = 200;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        progress_bar = true;
        # frame_color = "#eceff1";
        font = "JetBrains Nerd Font Mono 10";
      };

      # urgency_normal = {
      #   background = "#37474f";
      #   foreground = "#eceff1";
      #   timeout = 10;
      # };
      # urgency_critical = {
      #   timeout = 0;
      # };
    };
    iconTheme.name = "Adwaita";
    iconTheme.package = pkgs.gnome.adwaita-icon-theme;
    iconTheme.size = "32x32";
  };
}
