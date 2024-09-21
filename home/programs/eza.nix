{ ... }:
{

  # FIXME: find out why fish overwrites with an alias
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = true;
    extraOptions = [
      "--header"
      "--group-directories-first"
      "--across"
      "--dereferece"
    ];
  };

}
