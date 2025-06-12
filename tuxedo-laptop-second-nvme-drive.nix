{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [];

  fileSystems."/mnt/games" = {
    fsType = "btrfs";
    device = "/dev/nvme1n1p1";
    # device = "/dev/disk/by-uuid/52D0-5E93";
    # https://manpages.ubuntu.com/manpages/noble/en/man8/mount.8.html#filesystem-independent%20mount%20options
    options = [
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount
      "exec" # Permit execution of binaries and other executable files.
      # "rw" # Mount the filesystem read-write.
    ];
  };
}
