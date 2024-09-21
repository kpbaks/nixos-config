{
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.lib) getExe;
  scripts.ocr =
    pkgs.writers.writeFishBin "ocr" { }
      # fish 
      ''
        # ${pkgs.tesseract}/bin/tesseract
        # ${pkgs.libnotify}/bin/notify-send
        # ${pkgs.pngquant}/bin/pngquant
        # ${pkgs.swappy}/bin/swappy
        # ${pkgs.jaq}/bin/jaq

        set -l selection (${pkgs.slurp}/bin/slurp)
        or exit

        set -l screenshotf (${pkgs.coreutils}/bin/mktemp --suffix .png)
        ${pkgs.grim}/bin/grim -g $selection $screenshotf
        set -l textf (${pkgs.coreutils}/bin/mktemp --suffix .txt)

        set -l title (status filename | path basename | string upper)
        set -l notification_id (${pkgs.libnotify}/bin/notify-send --print-id --transient $title "Extracting text from screen selection using OCR. Please wait ...")
        ${pkgs.tesseract}/bin/tesseract $screenshotf $textf 
        set -l text (${pkgs.coreutils}/bin/cat $textf)

        set -l body "<b>The following text was extracted from the selected region, and copied to your clipboard</b>

        <i>
          $text
        </i>
        "
        # set -l icon

        # ${pkgs.libnotify}/bin/notify-send --icon=$icon $title $body
        ${pkgs.libnotify}/bin/notify-send --replace-id=$notification_id $title $body

        fish_clipboard_copy <$textf

        ${pkgs.coreutils}/bin/rm $screenshotf $textf
      '';
in
{
  home.packages =
    with pkgs;
    [
      tesseract
    ]
    ++ (map getExe (builtins.attrValues scripts));

  xdg.desktopEntries.ocr = {
    name = "Tesseract OCR - Take Screenshot and do Optical Character Recognition on it";
    # exec = "emacsclient -- %u";
    exec = getExe scripts.systemd-failed-units;
    terminal = false;
    type = "Application";
    categories = [ "System" ];
    # actions = {
    #   restart = {
    #     exec = "${pkgs.lib.getExe scripts.systemd-failed-units} restart";
    #   };
    # };
  };
}
