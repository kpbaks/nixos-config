{
  lib,
  osConfig,
  pkgs,
  ...
}:
{

  programs.obs-studio.enable = osConfig.programs.obs-studio.enable;
  programs.obs-studio.plugins =
    with pkgs.obs-studio-plugins;
    [
      # waveform
      wlrobs
      obs-vaapi
      # obs-gstreamer
      # input-overlay
      # obs-shaderfilter
      # obs-vintage-filter
      # obs-composite-blur
      # obs-source-switcher
      # obs-gradient-source
      # obs-pipewire-audio-capture
    ]
    ++ lib.optional osConfig.programs.droidcam.enable pkgs.obs-obs-studio-plugins.droidcam-obs;
  # xdg.configFile."obs-studio/themes" = {
  #   source =
  #     (pkgs.fetchFromGitHub {
  #       owner = "catppuccin";
  #       repo = "obs";
  #       rev = "b17939991545bdd6232e688ec5004b6dfae46f69";
  #       hash = "sha256-1Stlcfcl/DZMPPqsShst849Ns0Lgk9D2SekMhTy7zZY=";
  #     })
  #     + "/themes";
  # };
}
