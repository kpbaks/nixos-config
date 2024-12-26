{
  config,
  lib,
  pkgs,
  ...
}:
let

  langs = [
    "dan"
    "eng"
  ];
  script =
    let
      gum = "${pkgs.gum}/bin/gum";
    in
    pkgs.writers.writeFishBin "ocr" { }
      # fish
      ''
        set -l selection (${pkgs.slurp}/bin/slurp)
        or exit

        set -l screenshotf (${pkgs.coreutils}/bin/mktemp --suffix .png)
        ${pkgs.grim}/bin/grim -g $selection $screenshotf
        set -l textf (${pkgs.coreutils}/bin/mktemp)

        # set -l title (status filename | path basename | string upper)
        set -l title "OCR"
        set -l notification_id (${pkgs.libnotify}/bin/notify-send --print-id --transient $title "Extracting text from screen selection using OCR. Please wait ...")
        ${gum} spin --title "Doing OCR on screenshot ..." ${pkgs.tesseract}/bin/tesseract -l ${lib.concatStringsSep "+" langs} $screenshotf $textf 
        set textf "$textf.txt" # tesseract adds a `.txt` postfix to the output file
        set -l text (${pkgs.coreutils}/bin/cat $textf)

        set -l body (string join "\n" "<b>The following text was extracted from the selected region, and copied to your clipboard:</b>" "" "<i>$text</i>")

        # echo "body: $body"
        # set -l icon

        # ${pkgs.libnotify}/bin/notify-send --icon=$icon $title $body
        ${pkgs.libnotify}/bin/notify-send --replace-id=$notification_id $title $body

        fish_clipboard_copy <$textf

        ${pkgs.coreutils}/bin/rm $screenshotf $textf
      '';
in
{
  home.packages = [ script ];

  xdg.desktopEntries.ocr = {
    name = "Tesseract OCR - Take Screenshot and do Optical Character Recognition on it";
    exec = lib.getExe script;
    terminal = false;
    type = "Application";
    categories = [ "System" ];
  };

  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+O".action = spawn (lib.getExe script);
  };
}
