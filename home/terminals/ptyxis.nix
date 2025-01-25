{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ptyxis
  ];
  # https://conemu.github.io/en/AnsiEscapeCodes.html#ConEmu_specific_OSC
}
