{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:
{
  nixpkgs.system = lib.mkForce "aarch64-linux";
  nixpkgs.buildPlatform.system = "x86_64-linux";
  nixpkgs.hostPlatform.system = "aarch64-linux";
  environment.systemPackages = with pkgs; [
    libsForQt5.plasma-bigscreen
    helix
  ];

  isoImage.squashfsCompression = "lz4";
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
    settings = { };
    input = { };
    network = { };
  };

  networking.hostName = "raspberry-pi";
  # networking.networkmanager.enable = true;
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";

  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  programs.fish.enable = true;

  users.users.kpbaks = {
    isNormalUser = true;
    description = "Kristoffer Plagborg Bak Sørensen";
    # TODO: document why it is necessary to be part of each group
    extraGroups = pkgs.lib.lists.unique (
      [
        "networkmanager"
        "wheel"
        "docker"
        "storage"
        "i2c-dev"
      ]
      ++ (if config.virtualisation.podman.enable then [ "podman" ] else [ ])
    );
    packages = [ ]; # managed by home-manager, see ./home.nix
  };
  users.groups.input.members = [ username ];

  services.tailscale.enable = true;
  virtualisation.containers.enable = true;
  virtualisation.podman.enable = true;
  # show dots when typing password for sudo
  security.sudo.extraConfig = ''
    Defaults env_reset,pwfeedback
  '';

  programs.bandwhich.enable = true;
  services.syncthing.enable = true;

  services.rustdesk-server.enable = true;
  services.rustdesk-server.openFirewall = true;
  services.xserver = {
    enable = true;
    videoDrivers = [ "fbdev" ];

  };
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  # Prevent host becoming unreachable on wifi after some time.
  # networking.networkmanager.wifi.powersave = false;
}
