# https://yazi-rs.github.io/docs/configuration/yazi#manager.linemode
let
  linemode = "size_and_mtime";
in
{
  programs.yazi.initLua = # lua
    ''
      -- ~/.config/yazi/init.lua
      function Linemode:${linemode}()
      	local time = math.floor(self._file.cha.modified or 0)
      	if time == 0 then
      		time = ""
      	elseif os.date("%Y", time) == os.date("%Y") then
      		time = os.date("%b %d %H:%M", time)
      	else
      		time = os.date("%b %d  %Y", time)
      	end

      	local size = self._file:size()
      	return ui.Line(string.format("%s %s", size and ya.readable_size(size) or "-", time))
      end
    '';

  programs.yazi.settings.mgr.linemode = linemode;

}
