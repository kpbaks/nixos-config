{ pkgs, ... }:
{
  home.packages = with pkgs; [ the-way ];

  home.file.".config/the-way/config.toml".source = (pkgs.formats.toml { }).generate "the-way-config" {
    theme = "base16-ocean.dark";
    copy_cmd = "${pkgs.wl-clipboard}/bin/wl-copy --trim-newline";
  };

}
