{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lldb
    zls
    # zig
  ];
}
