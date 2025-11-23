# TODO: package this plugin https://github.com/nvchad/minty
{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim.enable = true;
  programs.nixvim.package =
    inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
  programs.nixvim.extraPackages = with pkgs; [
    gnumake
    tree-sitter
    nodejs # for copilot.lua
    marksman # markdown lsp
    libgit2 # c library to interact with git repositories, needed by fugit2.nvim plugin

    # nice for configuring neovim
    stylua # formatter
    selene # linter
    lua-language-server # lsp
    lua51Packages.lua
    libgit2
    luajit
    luajitPackages.luarocks
    ripgrep
    fd
  ];
  programs.nixvim.vimdiffAlias = true;
  programs.nixvim.diagnostics = {
    virtual_lines.only_current_line = true;
    virtual_text = true;
  };
  programs.nixvim.globals = {
    mapleader = " ";
    maplocalleader = " ";
    # Disable useless providers
    loaded_ruby_provider = 0; # Ruby
    loaded_perl_provider = 0; # Perl
    loaded_python_provider = 0; # Python 2

  };
  programs.nixvim.clipboard = {
    # Use system clipboard
    register = "unnamedplus";
    providers.wl-copy.enable = true;
  };
  programs.nixvim.opts = {
    updatetime = 100;
    relativenumber = true;
    number = true;
    hidden = true;
    mouse = "a";
    splitbelow = true;
    splitright = true;

    swapfile = false;
    undofile = true;
    incsearch = true;

    tabstop = 4;
    shiftwidth = 4;
    expandtab = false;
    autoindent = true;
    signcolumn = "yes";
    spell = true;
    spelllang = "en_us";
  };

  programs.nixvim.autoGroups =
    let
      togroup =
        strings:
        builtins.listToAttrs (
          map (s: {
            name = s;
            value = {
              clear = true;
            };
          }) strings
        );
    in

    togroup [
      "highlight-yank"
      "custom"
    ];

  programs.nixvim.autoCmd = [

    {
      event = [ "TextYankPost" ];
      desc = "Highlight when yanking (copying) text";
      group = "highlight-yank";
      callback.__raw = ''
        function()
          vim.highlight.on_yank()
        end
      '';
    }
    # {
    #   event = [ "VimEnter" ];
    #   group = "custom";
    #   callback.__raw = ''
    #     function()
    #     MiniMap.open()

    #     end

    #   '';
    # }
  ];

  # TODO: make a keybind `<leader>a` that check if there is a code action available for the cursor position, and opens a panel to select a handler
  # if not then check if there is a mispell and suggest `z=`
  # if not then go to next code action or mispell, whichever is closest.
  programs.nixvim.keymaps =
    let
      mode = [
        "n"
        "x"
      ];
      cmd = verb: "<cmd>${verb}<cr>";
      leader = keys: "<leader>${keys}";
      ctrl = key: "<c-${key}>";
    in

    [
      {
        action = cmd "bprevious";
        key = "gp";
        inherit mode;

        options.silent = true;
        options.desc = "focus previous buffer";
      }
      {
        action = cmd "bnext";
        key = "gn";
        options.silent = true;
        options.desc = "focus next buffer";
        inherit mode;
      }
      {
        action = cmd "bdelete";
        key = leader "q";
        inherit mode;
      }
      {
        action = "G";
        key = "ge";
        inherit mode;
      }
      {
        key = ctrl "s";
        action = cmd "update";
        inherit mode;

      }
      {
        action = cmd "Telescope find_files";
        key = "<leader>f";
        inherit mode;
      }
      {
        action = cmd "Telescope diagnostics";
        key = "<leader>d";
        inherit mode;
      }
      {
        key = "gw";
        mode = [
          "n"
          "x"
          "o"
        ];
        action.__raw = ''
          function() require("flash").jump() end
        '';
        # option.desc = "Flash";
      }
    ];

  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      lua_ls.enable = true;
      nixd.enable = true;
    };
  };
  programs.nixvim.plugins.fidget.enable = true;
  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true;
    };

    settings = {
      extensions.__raw = "{ ['ui-select'] = { require('telescope.themes').get_dropdown() } }";
    };
  };
  programs.nixvim.plugins.nvim-autopairs.enable = true;
  programs.nixvim.plugins.indent-blankline = {
    enable = true;
    settings = {
      exclude = {
        buftypes = [
          "terminal"
          "quickfix"
        ];
        filetypes = [
          ""
          "checkhealth"
          "help"
          "lspinfo"
          "packer"
          "TelescopePrompt"
          "TelescopeResults"
          "yaml"
        ];
      };
      indent = {
        char = "│";
      };
      scope = {
        show_end = false;
        show_exact_scope = true;
        show_start = false;
      };
    };
  };
  programs.nixvim.plugins.oil.enable = true;
  programs.nixvim.plugins.gitsigns.enable = true;
  programs.nixvim.plugins.neogit = {
    enable = true;
  };
  programs.nixvim.plugins.treesitter = {
    enable = true;
    settings = {
      auto_install = true;
      ensure_installed = [
        "bash"
        "c"
        "diff"
        "html"
        "css"
        "nu"

        "lua"
        "luadoc"
        "markdown"
        "markdown_inline"
        "query"
        "vim"
        "vimdoc"
        "nix"
        "fish"
        "python"
        "rust"
      ];
      indent.enable = true;
      sync_install = false;
      highlight = {
        additional_vim_regex_highlighting = true;
        custom_captures = { };
        disable = [
          # "rust"
        ];
        enable = true;
      };
    };
  };

  # programs.nixvim.plugins.luasnip.enable = true;
  # programs.nixvim.extraLuaPackages = ps: [
  #   # Required by luasnip
  #   ps.jsregexp
  # ];

  # programs.nixvim.plugins.cmp = {
  #   enable = true;
  #   autoEnableSources = true;
  #   settings.sources = [
  #     { name = "nvim_lsp"; }
  #     { name = "path"; }
  #     { name = "buffer"; }
  #   ];
  #   settings.completion.completeopt = "menu,menuone,noinsert";
  #   settings.mapping = {
  #     "<C-n>" = "cmp.mapping.select_next_item()";
  #     "<C-p>" = "cmp.mapping.select_prev_item()";
  #     "<C-y>" = "cmp.mapping.confirm { select = true }";
  #     "<C-Space>" = "cmp.mapping.complete {}";

  #   };
  # };

  # programs.nixvim.plugins.diffview = {
  #   enable = true;
  #   enhancedDiffHl = true;
  # };

  programs.nixvim.plugins.flash = {
    enable = true;
    settings = {
      continue = true;
      modes.char.jump_labels = true; # `f` `t` `F` and `T` with labels
    };
  };
  programs.nixvim.plugins.markview.enable = true;
  # programs.nixvim.plugins.trim.enable = true;
  programs.nixvim.plugins.zen-mode.enable = true;
  programs.nixvim.plugins.rest.enable = true;
  programs.nixvim.plugins.lualine.enable = true;
  programs.nixvim.plugins.mini = {
    enable = true;
    mockDevIcons = true;
    modules = {
      ai = {
        n_lines = 100;
        search_method = "cover_or_next";
      };
      clue = { };
      cursorword = { };
      # TODO: map to ctrl-c
      comment = { };
      files = { };
      icons = { };
      # jump = { };
      # indentscope = { };
      trailspace = { };
      map = { };
      tabline = { };
      # hipatterns = {
      # TODO: figure out how to do this
      # highlighters.__raw = ''
      #     -- Highlight hex color strings (`#rrggbb`) using that color
      #     hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
      # '';
      # };
      # };
    };
  };

  programs.nixvim.plugins.yazi.enable = true;
  programs.nixvim.plugins.notify.enable = true;

  programs.nixvim.plugins.none-ls.enable = true;
  programs.nixvim.plugins.crates.enable = true;
  programs.nixvim.plugins.todo-comments = {
    enable = true;
    settings.signs = true;
  };

  programs.nixvim.colorschemes.tokyonight = {
    enable = true;
    settings.style = "night";
  };
  programs.nixvim.colorschemes.catppuccin = {
    enable = false;
    settings = {
      flavour = "macchiato";
      dim_inactive = {
        enable = true;
        percentage = 0.1;
      };
    };
  };

  programs.nixvim.performance = {
    byteCompileLua = {
      enable = true;
      configs = true;
      initLua = true;
      nvimRuntime = true;
      plugins = true;
    };
  };

  # programs.nixvim.extraConfigLuaPost = # lua
  #   ''
  #     local
  #   '';
}
