{ config, pkgs, ... }:
{
  programs.fish.shellAbbrs = {
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
    fap = "fish_add_path";
    fkr = "fish_key_reader";

    kdec = {
      function = "__abbr_kdeconnect_cli";
    };
    e = "$EDITOR";
  };

  programs.fish.functions = {
    __abbr_kdeconnect_cli = # fish
      ''
        set -l devices (kdeconnect-cli --id-only --list-available)
        switch (count $devices)
            case 1
                echo "kdeconnect-cli --device=$devices[1]"
            case '*'
                echo kdeconnect-cli
        end
      '';
  };
}
