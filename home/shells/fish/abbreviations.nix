{
  config,
  lib,
  pkgs,
  ...
}:
let
  abbrs =
    attrs:
    with builtins;
    mapAttrs (
      _: v:
      if isAttrs v then
        v
      else if isString v && lib.strings.hasInfix "%" v then
        {
          setCursor = true;
          expansion = v;
        }
      else
        { expansion = v; }
    ) attrs;
in
{
  programs.fish.shellAbbrs = abbrs {
    cmdl = "commandline";
    bn = "path basename";
    dn = "path dirname";
    fcc = "fish_clipboard_copy";
    fcp = "fish_clipboard_paste";
    hm = "home-manager";
    hmg = "home-manager generations";
    nhhs = "nh home switch";
    nhs = "nh search --platforms";
    nhos = "nh os switch";
    sys = "systemctl";
    sysu = "systemctl --user";
    dtm = "datamash";
    jpt = "jupyter";
    jptl = "jupyter lab";
    # h = {
    #   expansion = "history search '%'";
    #   setCursor = true;
    # };

    h = "history search '%'";
    pk = "pkill -KILL";
    pg = "pgrep";
    upper = "string upper --";
    lower = "string lower --";
    len = "string length --";
    # brs = ''br --trim-root --cmd 'cr/%/i:open_preview'';
    brs = "br --trim-root --cmd 'cr/%/i:open_preview'";
    # m = {
    #   setCursor = true;
    #   expansion = ''string match "*%*"'';
    # };
    m = ''string match "*%*"'';
    re = ''string match --regex "^%\$"'';

    fi = "fish_indent --ansi";
    # fap = "fish_add_path";
    fkr = "fish_key_reader --continuous --verbose";

    kdec.function = "_abbr_kdeconnect_cli";
    # e = "$EDITOR";
    e.function = "_abbr_editor";

    r = "root";
    ef.function = "_abbr_exec_fish";

    multidot = {
      setCursor = true;
      regex = ''\b\.\.+\b'';
      function = "_abbr_multidot";
      # position = "command";
      position = "anywhere";
    };
  };

  # programs.fish.shellAbbrs.ns = mkIf osConfig.programs.nh.enable "nh search --limit 5 ";

  programs.fish.functions = {
    _abbr_multidot = # fish
      ''
        # path resolve
        if string match --regex '^\s*$' -- (commandline)
          echo -n "builtin cd"
        end
        set -l count (math (string length -- $argv[1]) - 1)
        printf '%s%%\n' (string repeat --count=$count '../')
      '';
    _abbr_editor =
      let
        git = "${config.programs.git.package}/bin/git";
        # fd = "${config.progams.fd.package}/bin/fd}";
      in
      # fish
      ''
        if test $HOME -eq $PWD
          # Do not want to do an expensive traversal of the entire $HOME tree
          echo \$EDITOR
        else if ${git} rev-parse --show-toplevel 2>/dev/null >&2
          # Check if repo is dirty
          if ${git} diff --quiet
            # FIXME: handle empty repository case
            # FIXME: handle if the changed file is binary or text e.g. use `isutf8` or `file --mime`
            # FIXME: handle if the file does no longer exist in the current repo state
            ${git} log -1 --diff-filter=AMR
            ${git} show @ --stat
          else
            set -l modified_files
          end
        else
          # TODO: find most recent (mtime) text file, and append it
          # set -l files (path filter --type=file --perm=write .* **)
          # set -l mtimes (echo $files | path mtime)
          set -l now (command date +%s)
          set -l not_modified_more_than_ago 600 # seconds
          set -l files
          path filter --type=file --perm=write .* ** | while read file
            set -l mtime (path mtime $file)
            test (math $now - $mtime) -gt $not_modified_more_than_ago; and continue
            set -a files $file
          end

          echo \$EDITOR $files
        end
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
