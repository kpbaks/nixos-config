{
  config,
  lib,
  pkgs,
  ...
}:
let
  plugin_name = "goto-project-root-dir";
  title = "${plugin_name}.yazi";
  git = "${config.programs.git.package}/bin/git";
in
{
  # ---@sync entry
  xdg.configFile."yazi/plugins/${plugin_name}.yazi/main.lua".text = # lua
    ''
      return {
        entry = function(self, job)
          -- shell 'ya pub dds-cd --str "$(git rev-parse --show-toplevel)"' --confirm
          -- local cwd = cx.active.current.cwd
          -- local toplevel = os.execute "${git} rev-parse --show-toplevel"
          local output, err = Command("${git}"):args({"rev-parse", "--show-toplevel"}):output()
          ya.dbg(output)

          if err ~= nil then
            ya.notify {
              title = "${title}",
              content = "err ~= nil " .. err,
              timeout = 5.0,
              level = "error",
            }
            return
          end

          -- git returns exitcode 128, if cwd is not in a git project
          if not output.status.success then
            ya.notify {
              title = "${title}",
              content = output.stderr,
              timeout = 5.0,
              level = "error",
            }
            return
          -- output.status.code
          end
          ya.notify {
          	title = "${plugin_name}",
          	content = "output.stdout = " .. output.stdout,
          	timeout = 6.5,
          	level = "info",
          }

          local workspace_root_dir = output.stdout .. "/"

          ya.manager_emit("cd", { workspace_root_dir })
          -- ya.manager_emit("enter", {})
          ya.manager_emit("forward", {})
          -- ya.manager_emit("cd", { "/etc/nixos" })
        end
      }
    '';

  programs.yazi.keymap.manager.prepend_keymap = [
    {
      on = [
        "g"
        "r"
      ];
      run = "plugin ${plugin_name}";
      desc = "cd to the root of the current git repository";
    }
  ];
}

# {
#   on = [
#     "g"
#     "r"
#   ];
#   # FIXME: does nothing
#   run = ''
#     shell 'ya pub dds-cd --str "$(git rev-parse --show-toplevel)"' --confirm
#   '';
#   desc = "cd back to the root of the current git repository";
# }
