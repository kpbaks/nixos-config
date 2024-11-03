{ lib, ... }:
{
  # NOTE: returns all files, not just `.nix` files
  # imports = lib.filesystem.listFilesRecursive ./.;
  imports = [

    ./show-outputs.nix
    ./notify-when-keyboard-layout-changes.nix
  ];
}
