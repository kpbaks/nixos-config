{ ... }:
{

  # FIXME: find out why fish overwrites with an alias
  programs.eza = {
    enable = true;
    enableFishIntegration = false;
    git = true;
    icons = true;
    extraOptions = [
      "--header"
      "--group-directories-first"
      "--across"
      "--dereference"
    ];
  };

}
