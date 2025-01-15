{
  programs.zathura = {
    enable = false;
    mappings = {
      "" = "navigate next";
      # D = "toggle_page_mode";
      "[fullscreen] " = "zoom in";
      ge = "G";
    };
    extraConfig = ''
      set selection-clipboard clipboard
      set recolor true
      map D set "first-page-column 1:1"
      map <C-d> set "first-page-column 1:2"
      map ge bottom
    '';
  };
}
