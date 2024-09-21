{ config, ... }:
{

  programs.aerc.enable = false;

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
}
