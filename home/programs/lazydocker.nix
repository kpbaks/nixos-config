{ pkgs, ... }:
{
  home.packages = with pkgs; [ lazydocker ];
  programs.fish.shellAbbrs.lzd = "lazydocker";
}
