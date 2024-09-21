{ pkgs, ... }:
{

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
