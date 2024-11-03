{ config, pkgs, ... }:
{
  # TODO: get steam to work
  # specialisation.gaming.configuration = {
  environment.systemPackages = with pkgs; [
    steamcmd
    steam-tui
    gamescope
  ];

  programs.steam = {
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    extraPackages = with pkgs; [ ];
    gamescopeSession.enable = false;
    # remotePlay.openFirewall = false;
  };

  # programs.steam.extest.enable = true;
  programs.steam.enable = true;

  programs.gamescope.enable = true;
  hardware.steam-hardware.enable = true;
  programs.gamemode.enable = true;

  # system.nixos.tags = [ "gaming" ];
  # Nvidia Configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.prime =
    let
      inherit (pkgs.lib) mkForce;
    in
    {
      sync.enable = mkForce false;
      offload = rec {
        enable = mkForce true;
        enableOffloadCmd = enable;
      };

      # NOTE: ids found with `lspci | grep VGA`
      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:01:00:0";
      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:00:02:0";
    };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  # Enable the Nvidia settings menu,
  # accessible via `nvidia-settings`.
  hardware.nvidia.nvidiaSettings = true;
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;

  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #   version = "555.52.04";
  #   sha256_64bit = "sha256-nVOubb7zKulXhux9AruUTVBQwccFFuYGWrU1ZiakRAI=";
  #   sha256_aarch64 = pkgs.lib.fakeSha256;
  #   openSha256 = pkgs.lib.fakeSha256;
  #   settingsSha256 = "sha256-PMh5efbSEq7iqEMBr2+VGQYkBG73TGUh6FuDHZhmwHk=";
  #   persistencedSha256 = pkgs.lib.fakeSha256;
  # };
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
  # };
}
