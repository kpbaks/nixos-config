{ config, pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type file";
    # FIXME: this does not match the generated $FZF_DEFAULT_OPTS
    defaultOptions = [
      "--height=~50%"
      "--border"
      "--ansi"
      "--cycle"
      "--layout=reverse-list"
      "--scroll-off=5"
      "--filepath-word"
      # "--jump-labels="
      "--bind space:jump"
      # "--pointer='|>'"
      "--pointer='=>'"
      "--marker='✔'"
      # TODO: change cursor icon
    ];
    enableFishIntegration = false;
  };
  # TODO: integrate with border.fish
  # EXIT STATUS
  #        0      Normal exit
  #        1      No match
  #        2      Error
  #        126    Permission denied error from become action
  #        127    Invalid shell command for become action
  #        130    Interrupted with CTRL-C or ESC
}
