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
  script = pkgs.writeShellApplication {
    name = "ocr";
    runtimeInputs = with pkgs; [
      coreutils
      gum
      slurp
      grim
      libnotify
      tesseract
      wl-clipboard
    ];
    # checkPhase = [ "SC2181" ];
    excludeShellChecks = [ "SC2181" ];
    text = ''
      selection=$(slurp)
      [ $? -eq 0 ] || exit

      # tesseract adds a `.txt` postfix to the output file, so we do not do it
      textf=$(mktemp)
      screenshotf=$(mktemp --suffix .png)
      function cleanup() {
        rm "$screenshotf" "$textf"
      }

      trap cleanup EXIT
      grim "$selection" "$screenshotf"

      title="OCR"
      notification_id=$(notify-send --print-id --transient "$title" "Extracting text from screen selection using OCR. Please wait ...")
      gum spin --title "Doing OCR on screenshot ..." -- tesseract -l ${lib.concatStringsSep "+" langs} "$screenshotf" "$textf"

      detected_text=$(cat "$textf")

      body="<b>The following text was extracted from the selected region, and copied to your clipboard:</b>\n\n<i>$detected_text</i>"
      notify-send --replace-id="$notification_id" "$title" "$body"

      wl-copy <"$textf"
    '';
  };
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
    # Same keybind as Windows PowerToys
    "Mod+Shift+T".action = spawn (lib.getExe script);
  };
}
