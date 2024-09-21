{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./procs.nix
    ./erdtree.nix
    ./omm.nix
    ./youplot.nix
    ./jupyterlab.nix
  ];
}
