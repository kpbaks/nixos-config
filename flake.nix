{
  description = "@kpbaks' NixOS and home-manager configuration";

  # TODO(learn): what is the difference between `*` and `extra-*` options?
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = [
      "https://nix-community.cachix.org"
      # "https://insane.cachix.org"
      "https://cachix.cachix.org"
      "https://helix.cachix.org"
      "https://yazi.cachix.org"
      # "https://cache.garnix.io" # used by `ironbar`
      # "https://watersucks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "insane.cachix.org-1:cLCCoYQKkmEb/M88UIssfg2FiSDUL4PUjYj9tdo4P8o="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      # "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
    ];
  };

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # url = "git+file:///home/kpbaks/forks/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixgl = {
      url = "github:nix-community/nixGL";
    };
    jail-nix.url = "sourcehut:~alexdavid/jail.nix";

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      # url = "flake:local-niri-flake-fork";
      # url = "git+file:///home/kpbaks/forks/niri-flake";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    nixd = {
      url = "github:nix-community/nixd";
      # NOTE: Developer does not recommend to override the nixpkgs input
      # https://github.com/nix-community/nixd/blob/main/nixd/docs/editor-setup.md#:~:text=Note%20that%20please%20do%20NOT%20override%20nixpkgs%20revision%20for%20nixd%20inputs.
    };

    nil.url = "github:oxalica/nil";

    # ghostty = {
    #   url = "git+ssh://git@github.com/ghostty-org/ghostty";
    #   # inputs.nixpkgs-stable.follows = "nixpkgs-unstable";
    #   # inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    # };
    ghostty-shaders = {
      url = "github:hackr-sh/ghostty-shaders";
      flake = false;
    };
    # eldritch-theme-ghostty = {
    #   url = "github:eldritch-theme/ghostty";
    #   flake = false;
    # };
    # eldritch-theme-kitty = {
    #   url = "github:eldritch-theme/kitty";
    #   flake = false;
    # };
    # catppuccin.url = "github:catppuccin/nix";
    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    # stylix = {
    #   url = "github:danth/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   # inputs.home-manager.follows = "home-manager";
    # };

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    # fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    # inputs.patchy.url = "github:NikitaRevenco/patchy/main";
    # impermanence.url = "github:nix-community/impermanence";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "git+https://git.outfoxxed.me/outfoxxed/quickshell?ref=v0.2.0";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };

    git-subcommands = {
      url = "git+https://codeberg.org/kpbaks/git-subcommands.git";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    my-scripts = {
      url = "git+https://codeberg.org/kpbaks/scripts.git";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    gen-oci-annotations = {
      url = "git+https://codeberg.org/kpbaks/gen-oci-annotations.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # swww = {
    #   url = "github:LGFae/swww";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO: use
    # inputs.sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # inputs.agenix = {
    #   url = "github:ryantm/agenix";
    #   # optional, not necessary for the module
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   # optionally choose not to download darwin deps (saves some resources on Linux)
    #   inputs.darwin.follows = "";
    # };

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    ouch-yazi = {
      url = "github:ndtoan96/ouch.yazi";
      flake = false;
    };

    # tree-sitter-roc = {
    #   url = "github:faldor20/tree-sitter-roc";
    #   flake = false;
    # };

    nix_command_not_found_fish = {
      url = "github:kpbaks/nix_command_not_found.fish";
      flake = false;
    };
    private_mode_fish = {
      url = "github:kpbaks/private_mode.fish";
      flake = false;
    };
    # git_fish = {
    #   url = "github:kpbaks/git.fish";
    #   flake = false;
    # };
    # "gabbr.fish" = {
    gabbr_fish = {
      # FIXME(nix): this blocks forever if the repo has private visibility
      url = "git+https://codeberg.org/kpbaks/gabbr.fish.git";
      inputs.nixpkgs.follows = "nixpkgs";
      # flake = false;
    };
    ctrl_z_fish = {
      url = "github:kpbaks/ctrl-z.fish";
      flake = false;
    };
    nix_fish = {
      url = "github:kpbaks/nix.fish";
      inputs.nixpkgs.follows = "nixpkgs";
      # flake = false;
    };

    try.url = "github:tobi/try";

    # nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # nix-melt = {
    #   url = "github:nix-community/nix-melt";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
  # inputs.hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
  #
  #
  # inputs.crates-lsp.url = "github:kpbaks/crates-lsp/feature/flake";
  # inputs.crates-lsp.url = "/home/kpbaks/development/forks/crates-lsp";

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      jail-nix,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      hostname = "nixos";
      username = "kpbaks";
      system = "x86_64-linux";
      for-all-systems = lib.genAttrs [ system ];
      overlays = [
        inputs.nixgl.overlay
        # inputs.rust-overlay.overlays.default
        # inputs.hyprpanel.overlay
        # (final: prev: { ghostty = inputs.ghostty.packages.${system}.default; })
        # inputs.ghostty.overlays.releasefast
        # inputs.wired-notify.overlays.default
        inputs.niri.overlays.niri
        # (final: prev: { niri = final.niri-unstable; })
        # (final: prev: { woomer = inputs.woomer.packages.${system}.default; })
        # inputs.swww.overlays.default
        # (final: prev: { swww = inputs.swww.packages.${prev.system}.swww; })
        # (final: prev: { zjstatus = inputs.zjstatus.packages.${prev.system}.default; })
        inputs.yazi.overlays.default
        inputs.helix.overlays.default
        inputs.nixd.overlays.default
        inputs.nil.overlays.default
        # (final: prev: { television = inputs.television.packages.${prev.system}.default; })
        # inputs.neovim-nightly-overlay.overlay
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
        config.allowBroken = false;
        config.permittedInsecurePackages = [
          "olm-3.2.16"
          #   "electron-27.3.11"
        ];
      };
      # TODO: try out
      jail = jail-nix.lib.init pkgs;
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;

      checks = for-all-systems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = import ./git-hooks.nix { inherit pkgs; };
        };
      });

      devShells = for-all-systems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
          packages = with pkgs; [
            nixd
            nil
            update-nix-fetchgit
            # Needed for the various *.css files used
            vscode-langservers-extracted
          ];
        };
      });

      templates.dev-generic = {
        path = ./templates/dev/generic;
        description = "";
      };

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        specialArgs = {
          inherit inputs username;
        };
        modules = [
          ./modules/nixos
          ./configuration.nix
          {
            # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md#default-configuration--who-needs-configuration
            nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
          }
          {
            imports = [
              inputs.niri.nixosModules.niri

            ];
            # I get an error when I build for "attribute 'polkit-kde-agent' missing"
            # when the package set is `pkgs.libsForQt5`
            # systemd.user.services.niri-flake-polkit.serviceConfig.ExecStart =
            #   lib.mkForce "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
          }

          # ./k3s.nix
          # {
          #   imports = [
          #     inputs.nix-flatpak.nixosModules.nix-flatpak
          #   ];
          # }
          # inputs.sops-nix.nixosModules.sops
          # {
          #   imports = [ inputs.agenix.nixosModules.default ];
          #   environment.systemPackages = [ inputs.agenix.packages.${system}.default ];
          # }
          # {
          #   imports = [ inputs.nixos-cli.nixosModules.nixos-cli ];
          #   services.nixos-cli = {
          #     enable = true;
          #     # use_nvd = true;
          #     # apply.use_nom = true;
          #   };
          # }
          # inputs.catppuccin.nixosModules.catppuccin
          # { environment.systemPackages = [ inputs.nix-weather.packages.${system}.nix-weather ]; }
          # { environment.systemPackages = [ inputs.fh.packages.${system}.default ]; }
          # inputs.nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen7
          # inputs.sops-nix.nixosModules.sops
          # (
          #   { ... }:
          #   {
          #     # stylix.enable = true;

          #     # stylix.targets.console.enable = true; # Linux kernel console
          #   }
          # )
          # { environment.systemPackages = [ inputs.nix-melt.packages.${system}.default ]; }
        ];
      };

      homeConfigurations = {
        "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs username;
          };
          modules = [
            ./modules/home
            ./home
            {

              home.username = username;
              home.homeDirectory = "/home/" + username;
              # TODO: sync with `configuration.nix`
              home.stateVersion = "24.05";
              home.enableDebugInfo = false;
              home.preferXdgDirectories = true;
              # home.sessionSearchVariables = {
              #   MANPATH = [
              #     "\${xdg.configHome}/.local/share/man"
              #   ];
              # };
              # Let Home Manager install and manage itself.
              programs.home-manager.enable = true;
              # nixpkgs.config.allowUnfree = true;
              # nixpkgs.config.permittedInsecurePackages = [
              #   "olm-3.2.16"
              #   "electron-27.3.11"
              # ];
            }
            # (
            #   { config, ... }:
            #   let
            #     cfg = config.catppuccin;
            #   in
            #   {
            #     imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
            #     config.catppuccin.enable = true; # Enable for all available programs you're using!
            #     config.catppuccin.flavor = "mocha";
            #     config.catppuccin.accent = "lavender";

            #     options.flavor = pkgs.lib.mkOption { type = pkgs.lib.types.attrs; };

            #     config.flavor = pkgs.lib.mkIf cfg.enable (
            #       (pkgs.lib.importJSON (config.catppuccin.sources.palette + "/palette.json"))
            #       .${config.catppuccin.flavor}.colors
            #     );
            #   }
            # )
            # {
            #   imports = [ inputs.stylix.homeManagerModules.stylix ];
            #   stylix.enable = false;
            #   stylix.polarity = "dark";
            #   stylix.image = pkgs.fetchurl {
            #     # url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nixos-wallpaper-catppuccin-macchiato.png";
            #     url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nixos-wallpaper-catppuccin-macchiato.png?raw=true";
            #     sha256 = "SkXrLbHvBOItJ7+8vW+6iXV+2g0f8bUJf9KcCXYOZF0=";

            #     # url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
            #     # sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
            #   };
            # }

            # (
            #   {
            #     config,
            #     pkgs,
            #     ...
            #   }:
            #   {
            #     imports = [ inputs.stylix.homeModules.stylix ]; # provide theming for system level programs such as bootloaders, splash screens, and display managers

            #     stylix = {
            #       enable = true;
            #       # https://nix-community.github.io/stylix/tricks.html#dynamic-wallpaper-generation-based-on-selected-theme
            #       image = config.lib.stylix.pixel "base0A";
            #       base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
            #       # image = pkgs.fetchurl {
            #       #   url = "https://preview.redd.it/character-visuals-original-illustration-by-shadow-v0-t7xz7a27w74f1.jpeg?width=1080&crop=smart&auto=webp&s=1679feb9b3954ff8ebab129beb8e8f8cd4a713f7";
            #       #   hash = lib.fakeHash;
            #       # };
            #       targets.console.enable = true; # Linux kernel console
            #       polarity = "dark";
            #     };
            #   }
            # )
            {
              imports = [
                inputs.nix-index-database.homeModules.nix-index
              ];
              programs.nix-index-database.comma.enable = true;
            }
            (
              { config, ... }:
              {
                imports = [ inputs.try.homeManagerModules.default ];
                programs.try = {
                  enable = true;
                  path = "${config.home.homeDirectory}/experiments";
                  # path = "~/experiments"; # optional, defaults to ~/src/tries

                };
              }
            )
            # { home.packages = [ inputs.steel.packages.${system}.default ]; }
            { home.packages = [ inputs.gen-oci-annotations.packages.${system}.default ]; }
            # { home.packages = [ inputs.crates-lsp.packages.${system}.default ]; }
          ];
        };
      };

      # TODO: crazy project idea, but hear me out
      nixosConfigurations.playstation4 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs username;
        };
        # system = "aarch64-linux";
        modules = [ ];
      };
      # TODO: setup raspberrypi
      # TODO: setup nextcloud
      nixosConfigurations.raspberry-pi = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs username;
        };
        system = "aarch64-linux";
        modules = [
          ./hosts/raspberry-pi.nix
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          (
            { modulesPath, ... }:
            {
              imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
            }
          )
        ];
      };

    };

}
