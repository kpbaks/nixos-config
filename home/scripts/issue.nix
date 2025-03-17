{
  config,
  lib,
  pkgs,
  ...
}:
let
  git = "${lib.getExe config.programs.git.package}";
  gh = "${lib.getExe config.programs.gh.package}";
  script =
    pkgs.writers.writeFishBin "issue" { }
      # fish
      ''
        if not ${git} rev-parse --is-inside-work-tree >/dev/null
          return 2
        end

        # TODO: detect which git forge this repo is connected with
        set -l remote_name origin
        set -l remote_url (${git} remote get-url $remote_name)
        if not string match --quiet "https://github.com/*" -- $remote_url
          return 2
        end

        set -l branch_name (${git} branch --show-current)
        string match --groups-only --regex "^issue/(\d+)" | read issue
        if test $pipestatus[1] -ne 0
          return 2
        end

        ${gh} issue view $issue
      '';

in
{
  home.packages = [ script ];
}
