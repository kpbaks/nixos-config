{ pkgs, ... }:
{

  imports = [
    ./abbreviations.nix
    ./aliases.nix
    ./functions.nix
    ./plugins.nix
    ./keybinds.nix
    ./themes.nix
    ./colors.nix
  ];
  home.packages = with pkgs; [
    grc # "generic colorizer" improves the output of many commands by adding colors
  ];

  programs.fish.enable = true;
  programs.fish.package = pkgs.fish;
  programs.fish.preferAbbrs = true;

  # https://github.com/NixOS/nix/blob/1068b9657ff1c4ea629a1a46e07391d16b88ff17/src/nix/develop.cc#L636
  programs.fish.interactiveShellInit = ''
    echo "todo: use $NIX_GCROOT as a marker being in a `nix develop` shell, and use it to diff the environment from the \"parent\" shell"
  '';
  #   echo "todo checkout \$status_generation"
  # '';
}

# # Implement keybinds similar to almost all text editors, where e.g.
# # "shift+home" selects everything from the cursor to the start of the line.

# # Inspiration:
# # - https://github.com/daleeidd/natural-selection

# # Used `fish_key_reader` to determine the keycode for the following key combinations:
# # - "shift+left" -> "\e\[1\;2D"
# # - "shift+right" -> "\e\[1\;2C"
# # - "shift+up" -> "\e\[1\;2A"
# # - "shift+down" -> "\e\[1\;2B"
# # - "ctrl+left" -> "\e\[1\;5D"
# # - "ctrl+right" -> "\e\[1\;5C"
# # - "ctrl+up" -> "\e\[1\;5A"
# # - "ctrl+down" -> "\e\[1\;5B"
# # - "ctrl+shift+left" -> "\e\[1\;6D"
# # - "ctrl+shift+right" -> "\e\[1\;6C"
# # - "ctrl+shift+up" -> "\e\[1\;6A"
# # - "ctrl+shift+down" -> "\e\[1\;6B"
# # - "home" -> "\e\[H"
# # - "end" -> "\e\[F"
# # - "shift+home" -> "\e\[1\;2H"
# # - "shift+end" -> "\e\[1\;2F"
# # - "ctrl+home" -> "\e\[1\;5H"
# # - "ctrl+end" -> "\e\[1\;5F"
# # - "ctrl+shift+home" -> "\e\[1\;6H"
# # - "ctrl+shift+end" -> "\e\[1\;6F"
# # - "ctrl+backspace" -> "\b"

# set -l escape \e

# function ctrl+shift+left

# end

# bind \e\[1\;6D ctrl+shift+left

# bind \b backward-kill-path-component
