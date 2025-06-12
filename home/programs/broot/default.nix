{ lib, pkgs, ... }:
{
  programs.broot = {
    enable = true;
    enableFishIntegration = true;
    settings = rec {
      modal = false;
      # icon_theme = "vscode";
      icon_theme = "nerdfont";
      default_flags = "-gh"; # show (h)idden files and status of files related to (g)it
      show_selection_mark = true;
      lines_before_match_in_preview = 2;
      lines_after_match_in_preview = lines_before_match_in_preview;
      # TODO: fetch github file extension colors and use here
      # https://dystroy.org/broot/conf_file/#colors-by-file-extension
      ext-colors = { } // (import ./github-language-colors.nix);
      # ext-colors = {

      # };
      enable_kitty_keyboard = lib.mkForce false;
      capture_mouse = true;
      transformers = [
        # Beutify JSON
        {
          input_extensions = [ "json" ];
          output_extension = "json";
          mode = "text";
          command = [ "${pkgs.jaq}/bin/jaq" ];
        }
        # Render PDF
        {
          input_extensions = [ "pdf" ];
          output_extension = "png";
          mode = "image";
          command = [
            "${pkgs.mupdf}/bin/mutool"
            "draw"
            "-w"
            "1000"
            "-o"
            "{output-path}"
            "{input-path}"
          ];
        }
        # Render Office files using libreoffice
        rec {
          input_extensions = [
            "xls"
            "xlsx"
            "doc"
            "docx"
            "ppt"
            "pptx"
            "ods"
            "odt"
            "odp"
          ];
          output_extension = "png";
          mode = "image";
          command = [
            "${pkgs.libreoffice}/bin/libreoffice"
            "--headless"
            "--convert-to"
            output_extension
            "--outdir"
            "{output-dir}"
            "{input-path}"
          ];
        }

        {
          # TODO: when this works sumbit a pr to add it to broots docs
          # https://dystroy.org/broot/conf_file/
          input_extensions = [ "d2" ];
          output_extension = "png";
          mode = "image";
          command = [
            "${pkgs.d2}/bin/d2"
            "{input-path}"
            "{output-path}"
          ];
        }
      ];
    };

  };
}
