{ inputs, ... }:
{

  imports = [
    inputs.wired-notify.homeManagerModules.default
  ];

  services.wired = {
    enable = false;
    config = ./wired.ron;
  };
}
