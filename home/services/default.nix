{ ... }:
{
  imports = [
    ./conky.nix
    ./darkman.nix
    ./espanso.nix
    ./glance.nix
    ./swayidle.nix
    ./swayosd.nix
    ./udiskie.nix
    ./wlsunset.nix
    ./wluma.nix
  ];

  services.trayscale.enable = false;
}
