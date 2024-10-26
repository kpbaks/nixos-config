{ ... }:
{
  programs.eza = {
    enable = true;
    enableFishIntegration = false;
    git = true;
    icons = "auto";
    extraOptions = [
      "--header"
      "--group-directories-first"
      "--across"
      "--dereference"
    ];
  };
}
