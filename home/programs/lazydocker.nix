{ pkgs, ... }:
{
  home.packages = with pkgs; [ lazydocker ];
  programs.fish.shellAbbrs.lzd = "lazydocker";
  programs.nushell.extraConfig = "alias lzd = ${pkgs.lazydocker}/bin/lazydocker";
}
