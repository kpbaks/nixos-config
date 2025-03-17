let
  plugin_name = "confirm-quit";
in
{
  # https://yazi-rs.github.io/docs/tips#confirm-quit
  xdg.configFile."yazi/plugins/${plugin_name}.yazi/main.lua".text = # lua
    ''
      local count = ya.sync(function() return #cx.tabs end)

      local function entry()
      	if count() < 2 then
      		return ya.manager_emit("quit", {})
      	end

      	local yes = ya.confirm {
      		pos = { "center", w = 60, h = 10 },
      		title = "Quit?",
      		content = string.format("There are %d tabs open. Are you sure you want to quit?", count()),
      	}
      	if yes then
      		ya.manager_emit("quit", {})
      	end
      end

      return { entry = entry }
      	'';

  # programs.yazi.keymap.manager.prepend_keymap = [
  #   {
  #     on = "q";
  #     run = "plugin ${plugin_name}";
  #   }
  # ];
}
