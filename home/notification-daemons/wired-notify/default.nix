{ inputs, ... }:
{

  imports = [
    inputs.wired-notify.homeManagerModules.default
  ];

  services.wired = {
    enable = true;
    config = ./wired.ron;
  };
}
