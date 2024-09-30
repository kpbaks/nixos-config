{ ... }:
{
  programs.okular = {
    enable = true;
    accessibility.highlightLinks = true;
    general = {
      obeyDrm = false;
      showScrollbars = true;
      zoomMode = "fitPage";
      viewMode = "FacingFirstCentered";
    };
    performance = {
      enableTransparencyEffects = false;
    };
  };
}
