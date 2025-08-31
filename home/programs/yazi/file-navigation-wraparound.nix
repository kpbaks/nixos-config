# FIXME: does not work. Cursor no move (Tue Feb 11 10:03:10 PM CET 2025)
let
  plugin_name = "file-navigation-wraparound";
in
{
  # https://yazi-rs.github.io/docs/tips/#navigation-wraparound
  xdg.configFile."yazi/plugins/${plugin_name}.yazi/main.lua".text = # lua
    ''
        return {
      	entry = function(_, args)
      		local current = cx.active.current
      		local new = (current.cursor + args[1]) % #current.files
      		ya.manager_emit("arrow", { new - current.cursor })
      	end,
      }
    '';

  programs.yazi.keymap.mgr.prepend_keymap = [
    {
      on = [ "k" ];
      run = "plugin --sync ${plugin_name} -1";
    }
    {
      on = [ "j" ];
      run = "plugin --sync ${plugin_name} 1";
    }
    {
      on = [ "<Up>" ];
      run = "plugin --sync ${plugin_name} -1";
    }
    {
      on = [ "<Down>" ];
      run = "plugin --sync ${plugin_name} 1";
    }
  ];
}
