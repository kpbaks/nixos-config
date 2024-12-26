let
  user = "kpbaks";
in
{
  # networking.wireless = {
  #   enable = true;
  #   # https://nixos.wiki/wiki/Wpa_supplicant
  #   userControlled.enable = true; # allow non-root user to use `wpa_gui` and `wpa_cli`

  #   # networks = {
  #   #   WiFimodem-E3F3 =
  #   # }
  # };

  # users.extraUsers.${user}.extraGroups = [ "wheel" ];

  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    Settings.AutoConnect = true;
    Network.EnableIPv6 = true;
  };

  # networking.nftables.enable = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;
  # networking.networkmanager.wifi.macAddress = "random"; # "MAC spoofing"
  networking.networkmanager.wifi.backend = "iwd";

  networking.wireless.networks = {
    # obtained with `nix shell nixpkgs#wpa_supplicant --command wpa_passphrase WiFimodem-E3F3 <password>`
    # WiFimodem-E3F3.pskRaw = "ext:8a9aa53230c952d36dc6c6929cadd46bfedc1958b16a96aa6be6a09476cc7f2a";
    # "OnePlus Nord".pskRaw = "ext:e33aeecf333de5920983e0c79bee3bfc18a49c1a75ecb84b080b97d96f17ff5d";
  };
}
