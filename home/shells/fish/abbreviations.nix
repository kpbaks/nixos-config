{
  # config,
  # osConfig,
  # lib,
  pkgs,
  ...
}:
{
  programs.fish.shellAbbrs = {
    bn = "path basename";
    dn = "path dirname";
    fcc = "fish_clipboard_copy";
    fcp = "fish_clipboard_paste";
    hm = "home-manager";
    hmg = "home-manager generations";
    sys = "systemctl";
    sysu = "systemctl --user";
    dtm = "datamash";
    jpt = "jupyter";
    jptl = "jupyter lab";
    h = {
      expansion = "history search '%'";
      setCursor = true;
    };
    pk = "pkill -KILL";
    pg = "pgrep";
    upper = "string upper --";
    lower = "string lower --";
    len = "string length --";
    m = {
      setCursor = true;
      expansion = ''string match "*%*"'';
    };
    re = {
      setCursor = true;
      expansion = ''string match --regex "^%\$"'';
    };

    fi = "fish_indent --ansi";
    # fap = "fish_add_path";
    fkr = "fish_key_reader --continuous --verbose";

    kdec.function = "_abbr_kdeconnect_cli";
    # e = "$EDITOR";
    e.function = "_abbr_editor";

    r = "root";
    ef.function = "_abbr_exec_fish";
  };

  # programs.fish.shellAbbrs.ns = mkIf osConfig.programs.nh.enable "nh search --limit 5 ";

  programs.fish.functions = {
    _abbr_editor =
      # fish
      ''
        # TODO: find most recent text file, and append it
        echo \$EDITOR
      '';
    _abbr_kdeconnect_cli = # fish
      ''
        set -l devices (${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-cli --id-only --list-available)
        switch (count $devices)
            case 1
                echo "kdeconnect-cli --device=$devices[1]"
            case '*'
                echo kdeconnect-cli
        end
      '';

    _abbr_exec_fish = # fish
      ''
        set -l exe (path resolve /proc/$fish_pid/exe)
        echo "exec $exe"
      '';
  };
}
