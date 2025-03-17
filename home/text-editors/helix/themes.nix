{ pkgs, ... }:
let
  inherit (pkgs) fetchFromGitHub;
  carbon = fetchFromGitHub {
    owner = "rishikanthc";
    repo = "carbon-helix";
    rev = "3e024cb337de09f874579ef8dd5364b300405bb7";
    hash = "sha256-R+EhV25GRp/470kU7iQXELyYJbqn1Hu3LPVsGKgi5F0=";
  };
in
{
  programs.helix.themes.carbon = with builtins; fromTOML (readFile "${carbon}/carbon.toml");
  # programs.helix.settings.theme = "catppuccin_mocha";
  # programs.helix.settings.theme = "ao";
  # programs.helix.settings.theme = "pop-dark";
  # programs.helix.settings.theme = "tokyonight";
  # programs.helix.settings.theme = "gruvbox_dark_hard";
  # programs.helix.settings.theme = "kanagawa";
  # programs.helix.settings.theme = "base16_default_dark";
  # programs.helix.settings.theme = "material_deep_ocean";
  # programs.helix.settings.theme = "kaolin-dark";
  # programs.helix.settings.theme = "gruber-darker";
  # programs.helix.settings.theme = "carbon";
  programs.helix.settings.theme = "iceberg-dark";
}
