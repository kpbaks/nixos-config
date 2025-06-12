{
  imports = [
    ./portal.nix
    ./mime.nix
    ./desktop-entries.nix
  ];

  xdg.enable = true;
  # https://wiki.archlinux.org/title/XDG_user_directories
  xdg.userDirs.createDirectories = true;
  # https://manpages.debian.org/testing/xdg-terminal-exec/xdg-terminal-exec.1.en.htmlxdg.terminal-exec.enable = true;
  # xdg.terminal-exec.enable = true;
}
