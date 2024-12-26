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
    gamescope
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

  specialisation.gaming.configuration = {
    system.nixos.tags = [ "gaming" ];
    # Nvidia Configuration
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia-container-toolkit.enable = true;
    hardware.nvidia.powerManagement.enable = true;
    hardware.nvidia.powerManagement.finegrained = true;
    hardware.nvidia.dynamicBoost.enable = true;
    hardware.nvidia.gsp.enable = true; # supported by the discrete GPU in my laptop, "GeForce RTX 3060 Mobile / Max-Q"
    hardware.nvidia.open = true;
    hardware.nvidia.prime = {
      sync.enable = lib.mkForce false;
      offload = rec {
        enable = lib.mkForce true;
        enableOffloadCmd = enable; # adds `nvidia-offload` to `environment.systemPackages`
      };

      # NOTE: ids found with `lspci | grep VGA`
      nvidiaBusId = "PCI:01:00:0";
      intelBusId = "PCI:00:02:0";
    };

    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    programs.coolercontrol.nvidiaSupport = true;
    programs.coolercontrol.enable = true;

  };

  services.sunshine = {
    enable = false;
  };
}
