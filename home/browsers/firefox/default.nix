{ config, pkgs, ... }:
{

  imports = [ ./profiles ];
  programs.firefox.enable = true;
  # TODO: wrap in `web-ext`
  programs.firefox.package = pkgs.firefox;
  # programs.firefox.package = (
  #   pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { }
  # );
  # package = pkgs.firefox-devedition;
  # TODO: declare extensions here
  # FIXME: does not work
  # enableGnomeExtensions = config.services.gnome-browser-connector.enable;
  programs.firefox.policies = {
    DisablePocket = true;
    DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";
  };

  # https://nixos.wiki/wiki/Firefox
  home.sessionVariables.MOZ_USE_XINPUT2 = "1";
}
