{ config, pkgs, ... }:
{
  programs.aerc.enable = false;

  # programs.thunderbird.enable = true;
  # programs.thunderbird.package = pkgs.thunderbird;
  # programs.thunderbird.settings = {
  #   "general.useragent.override" = "";
  #   "privacy.donottrackheader.enabled" = true;
  # };

  # programs.thunderbird.profiles.personal = {
  #   name = "personal";
  #   isDefault = true;
  #   userContent = # css
  #     ''
  #       /* Hide scrollbar on Thunderbird pages */
  #       *{scrollbar-width:none !important}
  #     '';
  # };

  # # TODO: get to work
  # accounts.email.accounts.gmail = {
  #   address = "kristoffer.pbs@gmail.com";
  #   realName = "Kristoffer Plagborg Bak Sørensen";
  #   primary = true;
  #   flavor = "gmail.com";
  #   passwordCommand = pkgs.writeScript "email-password" "echo ...";
  #   himalaya.enable = true;
  #   thunderbird.enable = true;

  #   aerc.enable = config.programs.aerc.enable;
  # };

  programs.himalaya = {
    enable = false;
    settings = { };
  };
  services.himalaya-watch.enable = config.programs.himalaya.enable;

  # FIXME: get to work under wayland and nixos
  # systemd.user.services.birdtray = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service.ExecStart = "${pkgs.birdtray}/bin/birdtray";
  # };
}
