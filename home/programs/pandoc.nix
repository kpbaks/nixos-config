{ config, ... }:
{

  programs.pandoc.enable = true;
  programs.pandoc.defaults = {
    metadata = {
      # author = full-name;
      author = config.personal.name;
    };
    pdf-engine = "xelatex";
    # pdf-engine = "${pkgs.texliveSmall}/bin/xelatex";
    citeproc = true;
  };
}
