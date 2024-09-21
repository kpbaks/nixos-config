{ pkgs, ... }:
{

  programs.yt-dlp = {
    enable = true;
    settings = {
      embed-thumbnail = true;
      # embed-subs = true;
      # sub-langs = "all";
      downloader = "${pkgs.aria2c}/bin/aria2c";
      downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
    };
  };
}
