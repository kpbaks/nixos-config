# https://yazi-rs.github.io/docs/tips/#folder-rules
{ ... }:
{
  xdg.configFile."yazi/plugins/folder-rules.yazi/init.lua".text = # lua
    ''
      local function setup()
        ps.sub("cd", function()
          local cwd = cx.active.current.cwd
          if cwd:ends_with("Downloads") then
          ya.manager_emit("sort", { "modified", reverse = true, dir_first = false })
          else
          ya.manager_emit("sort", {"alphabetical", reverse = false, dir_first = true })
          end
        end)
      end

      return { setup = setup }
    '';

	  
  programs.yazi.initLua = # lua
    ''
      require("folder-rules"):setup()
    '';
}
