{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: get steam to work
  environment.systemPackages = with pkgs; [
    steamcmd
    # steam-tui
    # adwsteamgtk # TODO: how to apply?
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    # extraPackages = with pkgs; [ ];
    gamescopeSession.enable = false;
    # remotePlay.openFirewall = false;
  };

  programs.gamescope.enable = true;
  hardware.steam-hardware.enable = true;
  programs.gamemode.enable = true;

  # specialisation.gaming.configuration = {
  #   system.nixos.tags = [ "gaming" ];
  programs.coolercontrol.enable = false;
  services.sunshine.enable = false;
}
