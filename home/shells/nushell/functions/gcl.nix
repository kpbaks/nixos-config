{
  config,
  ...
}:
let
  git = "${config.programs.git.package}/bin/git";
in
{
  programs.nushell.extraConfig = # nu
    ''
        # let scopes = [system global local worktree command]
        let scope_colors = {
          system: (ansi red)
          global: (ansi red)
          local: (ansi red)
          worktree: (ansi red)
          command: (ansi red)
        }

      	${git} config --show-origin --show-scope --list
        | lines
        | parse "{scope}\tfile:{file}\t{option}={value}"
        | sort-by option
        | update file { str replace $env.HOME "~" }
        | update value { |row|
          match $row.value {
            "true" | "false" => ($row.value | into bool)
            _ => {
              try {
                $row.value | into int
              } catch {
                $row.value
              }
            }
          }
        }
        | group-by scope
      	'';
}
