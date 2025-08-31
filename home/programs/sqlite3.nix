{ pkgs, ... }:
{

  home.packages = with pkgs; [
    sqlite # sql database in a file
    # litecli # A nicer repl for sqlite
    # sqlitebrowser
  ];

  xdg.mimeApps.defaultApplications."application/vnd.sqlite3" = [
    "sqlitebrowser.desktop"
  ];

  programs.fish.functions.sqlite3 = # fish
    ''
      if status is-interactive
        and test (count $argv) -eq 2
        and test $argv[2] = .schema
        and isatty stdout
        command sqlite3 $argv | ${pkgs.bat}/bin/bat --language=sql --plain
      else
        ${pkgs.litecli}/bin/litecli $argv
      end
    '';

  # Make the output of `sqlite3` be more legible by default
  # https://vld.bg/tips/sqliterc/
  # home.file.".sqliterc".text = ''
  #   .headers on
  #   .changes on
  #   .timer on
  #   .mode box
  #   .databases
  #   .tables
  # '';

  # TODO: change
  # https://litecli.com/config/
  # xdg.configFile."litecli/config".text = '''';
}
