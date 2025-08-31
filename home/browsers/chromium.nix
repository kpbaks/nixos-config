{ pkgs, ... }:
{
  programs.chromium = {
    enable = false;
    # package = pkgs.chromium;
    package = pkgs.ungoogled-chromium;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      {
        id = "dcpihecpambacapedldabdbpakmachpb";
        updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
      }
    ];
  };
}
