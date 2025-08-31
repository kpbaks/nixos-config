{
  config,
  ...
}:
{

  xdg.configFile."yazi/plugins/pkg-config.yazi/main.lua".text =
    # lua
    ''
      --- @since 25.3.7

      local root = ya.sync(function() return cx.active.current.cwd end)
      local title = "$PKG_CONFIG_PATH"

      local function fail(content) return ya.notify { title = title, content = content, timeout = 5, level = "error" } end

      local function entry()
      	local PKG_CONFIG_PATH = os.getenv("PKG_CONFIG_PATH")
      	if PKG_CONFIG_PATH == nil then
          	return fail("Environment variable $PKG_CONFIG_PATH not set")
      	end
      	local root = root()
      	local id = ya.id("ft")
      	local cwd = root:into_search(title)
      	ya.mgr_emit("cd", { Url(cwd) })
      	ya.mgr_emit("update_files", { op = fs.op("part", { id = id, url = Url(cwd), files = {} }) })

      	local dirs = {}
      	-- split with ':'
        local sep = ":"
        for dir in string.gmatch(PKG_CONFIG_PATH, "([^"..sep.."]+)") do
            local url = Url(dir)
            local cha = fs.cha(url, true)
      		if cha then
      			table.insert(dirs, File { url = url, cha = cha })
      		end
        end

      	ya.mgr_emit("update_files", { op = fs.op("part", { id = id, url = Url(cwd), files = dirs }) })
      	ya.mgr_emit("update_files", { op = fs.op("done", { id = id, url = cwd, cha = Cha { kind = 16 } }) })
      end

      return { entry = entry }

    '';

  programs.yazi = {
    plugins = {
      # pkg-config = "${config.xdg.configHome}/yazi/plugins/pkg-config.yazi";
    };
    # initLua = # lua
    #   ''
    #     require("pkg-config"):setup()
    #   '';

    keymap.mgr.prepend_keymap = [
      {
        on = [
          "g"
          "P"
        ];
        run = "plugin pkg-config";
        desc = "Show *.pc in $PKG_CONFIG_PATH";
      }
    ];
  };
}
