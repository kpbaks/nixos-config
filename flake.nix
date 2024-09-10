{

  # TODO(package):
  # - https://github.com/siddrs/tokyo-night-sddm

  description = "@kpbaks' NixOS configuration";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = [
      "https://nix-community.cachix.org"
      # "https://insane.cachix.org"
      "https://cachix.cachix.org"
      "https://hyprland.cachix.org"
      "https://helix.cachix.org"
      "https://yazi.cachix.org"
      "https://cosmic.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "insane.cachix.org-1:cLCCoYQKkmEb/M88UIssfg2FiSDUL4PUjYj9tdo4P8o="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
  };

  # https://github.com/NixOS/nix/issues/4945#issuecomment-1869931785
  # inputs = let
  #   dep = url: { inherit url; inputs.nixpkgs.follows = "nixpkgs"; };
  # in {
  #   nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  #   nix-darwin = (dep "github:LnL7/nix-darwin");
  #   home-manager = (dep "github:nix-community/home-manager");
  #   zig = (dep "github:Cloudef/nix-zig-stdenv");
  #   zls = (dep "github:zigtools/zls");
  #   hyprland = (dep "github:hyprwm/Hyprland");
  #   eww = (dep "github:elkowar/eww");
  # };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # TODO use
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = "home-manager";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: what do i use this for?
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };
    # TODO: use
    # sops-nix.url = "github:Mic92/sops-nix";
    # TODO: use
    # nur.url = "github:nix-community/NUR";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-completion-language-server = {
      url = "github:estin/simple-completion-language-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    # TODO: use
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    # TODO: use
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: use
    # anyrun.url = "github:Kirottu/anyrun";
    # anyrun.inputs.nixpkgs.follows = "nixpkgs";
    # anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";

    # TODO: use
    ags.url = "github:Aylur/ags";
    # atdo.url = "github:kpbaks/atdo";
    # atdo.inputs.nixpkgs.follows = "nixpkgs";
    swww = {
      url = "github:LGFae/swww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: checkout
    # https://github.com/fufexan/nix-gaming

    # FIXME: why is no `nixos` binary available?
    nixos-cli = {
      url = "github:water-sucks/nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: try out and setup
    # https://github.com/Toqozz/wired-notify
    wired-notify = {
      url = "github:Toqozz/wired-notify";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      # self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      hostname = "nixos";
      username = "kpbaks";
      system = "x86_64-linux";
      overlays = [
        inputs.niri.overlays.niri
        # inputs.neovim-nightly-overlay.overlay
      ];
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
    in
    # pkgs = nixpkgs.legacyPackages.${system};
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;
      # TODO: use flake-checker
      # checks

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs username;
        };
        modules = [
          ./configuration.nix
          inputs.stylix.nixosModules.stylix # provide theming for system level programs such as bootloaders, splash screens, and display managers
          inputs.niri.nixosModules.niri
          inputs.nixos-cli.nixosModules.nixos-cli
          inputs.catppuccin.nixosModules.catppuccin

          # inputs.nixos-cosmic.nixosModules.default
          # inputs.nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen7
          # inputs.sops-nix.nixosModules.sops
          (
            { ... }:
            {
              # stylix.enable = true;

              # stylix.targets.console.enable = true; # Linux kernel console
            }
          )
        ];
      };

      homeConfigurations = {
        "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs username system;
          };
          modules = [
            ./home.nix
            # ./kde-plasma.nix
            inputs.niri.homeModules.niri
            (
              { ... }:
              {
                imports = [ inputs.nixvim.homeManagerModules.nixvim ];

                programs.nixvim.enable = true;
                programs.nixvim.package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
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
                  {
                    event = [ "VimEnter" ];
                    group = "custom";
                    callback.__raw = ''
                      function()
                      MiniMap.open()

                      end

                    '';
                  }
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
                    lua-ls.enable = true;
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
                programs.nixvim.plugins.treesitter = {
                  enable = true;
                  settings = {
                    auto_install = false;
                    ensure_installed = [
                      "bash"
                      "c"
                      "diff"
                      "html"
                      "css"

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

                programs.nixvim.plugins.luasnip.enable = true;
                programs.nixvim.extraLuaPackages = ps: [
                  # Required by luasnip
                  ps.jsregexp
                ];

                programs.nixvim.plugins.cmp = {
                  enable = true;
                  autoEnableSources = true;
                  settings.sources = [
                    { name = "nvim_lsp"; }
                    { name = "path"; }
                    { name = "buffer"; }
                  ];
                  settings.completion.completeopt = "menu,menuone,noinsert";
                  settings.mapping = {
                    "<C-n>" = "cmp.mapping.select_next_item()";
                    "<C-p>" = "cmp.mapping.select_prev_item()";
                    "<C-y>" = "cmp.mapping.confirm { select = true }";
                    "<C-Space>" = "cmp.mapping.complete {}";

                  };
                };

                programs.nixvim.plugins.diffview = {
                  enable = true;
                  enhancedDiffHl = true;
                };

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
                programs.nixvim.plugins.crates-nvim.enable = true;
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
              }
            )
            # inputs.anyrun.homeManagerModules.default
            # inputs.plasma-manager.homeManagerModules.plasma-manager
            # (
            #   { ... }:
            #   {
            #     imports = [ ./kde-plasma.nix ];
            #   }
            # )
            (
              { ... }:
              {
                imports = [
                  inputs.catppuccin.homeManagerModules.catppuccin
                ];
                catppuccin.enable = true; # Enable for all available programs you're using!
                catppuccin.flavor = "macchiato";
                catppuccin.accent = "lavender";
              }
            )
            (
              { pkgs, ... }:
              {
                imports = [
                  inputs.spicetify-nix.homeManagerModules.default
                ];
                programs.spicetify =
                  let
                    spicetify-pkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
                  in
                  {
                    enable = true;
                    enabledExtensions = with spicetify-pkgs.extensions; [
                      adblock
                      hidePodcasts
                      shuffle # shuffle+ (special characters are sanitized out of extension names)
                      autoVolume
                      betterGenres
                      powerBar
                    ];
                    enabledCustomApps = with spicetify-pkgs.apps; [
                      reddit
                      newReleases
                    ];
                    # theme = spicetify-pkgs.themes.fluent;
                    theme = spicetify-pkgs.themes.catppuccin;
                    colorScheme = "macchiato";
                  };
              }
            )
            (
              { ... }:
              {
                imports = [
                  inputs.stylix.homeManagerModules.stylix
                ];
                stylix.enable = false;
                stylix.polarity = "dark";
                stylix.image = pkgs.fetchurl {
                  # url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nixos-wallpaper-catppuccin-macchiato.png";
                  url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nixos-wallpaper-catppuccin-macchiato.png?raw=true";
                  sha256 = "SkXrLbHvBOItJ7+8vW+6iXV+2g0f8bUJf9KcCXYOZF0=";

                  # url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
                  # sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
                };
              }
            )
            (
              { ... }:
              {
                imports = [
                  inputs.plasma-manager.homeManagerModules.plasma-manager
                ];

                programs.plasma.enable = true;
                programs.kate.enable = true;
                programs.kate.editor.brackets = {
                  automaticallyAddClosing = true;
                  flashMatching = true;
                  highlightMatching = true;
                  highlightRangeBetween = true;
                };
                programs.kate.editor.font = {
                  family = "JetBrains Mono";
                  pointSize = 14;
                };

                programs.okular = {
                  enable = true;
                  accessibility.highlightLinks = true;
                  general = {
                    obeyDrm = false;
                    showScrollbars = true;
                    zoomMode = "fitPage";
                    viewMode = "FacingFirstCentered";
                  };
                  performance = {
                    enableTransparencyEffects = false;
                  };
                };

                # programs.plasma.kwin.enable = true;
                # programs.plasma.scripts.polonium.enable = true;

                programs.plasma.spectacle.shortcuts = {
                  # launch = null;
                  # enable = true;
                };

                programs.plasma.workspace.cursor = {
                  size = 24;
                  theme = "Breeze_Snow";
                };

                programs.plasma.workspace.iconTheme = "Papirus";
                programs.plasma.workspace.lookAndFeel = "org.kde.breeze.desktop";
              }
            )
          ];
        };
      };
    };
}
