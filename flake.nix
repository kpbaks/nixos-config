{
  # TODO(package):
  # - https://github.com/siddrs/tokyo-night-sddm

  description = "@kpbaks' NixOS configuration";

  # TODO(learn): what is the difference between `*` and `extra-*` options?
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
      "https://cache.garnix.io" # used by `ironbar`
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "insane.cachix.org-1:cLCCoYQKkmEb/M88UIssfg2FiSDUL4PUjYj9tdo4P8o="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs.pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  inputs.fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";

  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.zen-browser.url = "github:MarceColl/zen-browser-flake";
  inputs.zen-browser.inputs.nixpkgs.follows = "nixpkgs";

  inputs.ghostty = {
    url = "git+ssh://git@github.com/ghostty-org/ghostty";
    # inputs.nixpkgs-stable.follows = "nixpkgs-unstable";
    # inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    inputs.nixpkgs-stable.follows = "nixpkgs";
    inputs.nixpkgs-unstable.follows = "nixpkgs";
  };

  # TODO: use
  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # FIXME: why is no `nixos` binary available?
  inputs.nixos-cli = {
    url = "github:water-sucks/nixos";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.agenix = {
    url = "github:ryantm/agenix";
    # optional, not necessary for the module
    inputs.nixpkgs.follows = "nixpkgs";
    # optionally choose not to download darwin deps (saves some resources on Linux)
    inputs.darwin.follows = "";
  };

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

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

    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprspace = {
      url = "github:KZDKM/Hyprspace";

      # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
      inputs.hyprland.follows = "hyprland";
    };

    # # TODO: what do i use this for?
    # hyprgrass = {
    #   url = "github:horriblename/hyprgrass";
    #   inputs.hyprland.follows = "hyprland"; # IMPORTANT
    # };

    # TODO: use
    # nur.url = "github:nix-community/NUR";

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
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: use
    # anyrun.url = "github:Kirottu/anyrun";
    # anyrun.inputs.nixpkgs.follows = "nixpkgs";
    # anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";

    # TODO: use
    # ags = {
    #   url = "github:Aylur/ags";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # atdo.url = "github:kpbaks/atdo";
    # atdo.inputs.nixpkgs.follows = "nixpkgs";
    swww = {
      url = "github:LGFae/swww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # umu = {
    #   url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO: checkout
    # nix-gaming = {
    #   url = "github:fufexan/nix-gaming";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # TODO: try out and setup
    # https://github.com/Toqozz/wired-notify
    # wired-notify = {
    #   url = "github:Toqozz/wired-notify";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO: create a similar implementation that is native to `niri`
    # can use a similar overlay to the print screen feature
    # Should it be possible to zoom in, while stuff is being rendered?
    # TODO: upstream to nixpkgs
    woomer = {
      url = "github:coffeeispower/woomer";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ironbar = {
      url = "github:JakeStanger/ironbar";
      # url = "github:anant-357/ironbar"; # has "niri workspaces" pr waiting to be merged
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: checkout
    # https://github.com/vinceliuice/grub2-themes
    # grub2-themes = {
    #   url = "github:vinceliuice/grub2-themes";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    zjstatus = {
      url = "github:dj95/zjstatus";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rust-overlay = {
    #   url = "github:oxalica/rust-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-melt = {
      url = "github:nix-community/nix-melt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  inputs.hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      hostname = "nixos";
      username = "kpbaks";
      system = "x86_64-linux";
      used-systems = [ "x86_64-linux" ];
      for-all-systems = nixpkgs.lib.genAttrs used-systems;

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          inputs.hyprpanel.overlay
          # inputs.rust-overlay.overlays.default
          # inputs.wired-notify.overlays.default
          inputs.niri.overlays.niri
          (final: prev: { woomer = inputs.woomer.packages.${system}.default; })
          inputs.swww.overlays.default
          # (final: prev: { swww = inputs.swww.packages.${prev.system}.swww; })
          (final: prev: { zjstatus = inputs.zjstatus.packages.${prev.system}.default; })
          (final: prev: { yazi = inputs.yazi.packages.${prev.system}.default; })
          # inputs.neovim-nightly-overlay.overlay         
        ];
        config.allowUnfree = true;
      };
    in
    # pkgs = nixpkgs.legacyPackages.${system};
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;

      checks = for-all-systems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # nixpkgs-fmt.enable = true;
            nixfmt-rfc-style.enable = true;
            deadnix.enable = true;
            flake-checker.enable = true;
            statix.enable = true;
            check-toml.enable = true;
            check-json.enable = true;
            check-yaml.enable = true;
            lychee.enable = true;
          };
        };
      });

      devShells = for-all-systems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };

      });

      # TODO: setup raspberrypi
      # TODO: setup nextcloud
      # nixosConfigurations."raspberrypi" = nixpkgs.lib.nixosSystem {
      #   specialArgs = {
      #     inherit inputs username;
      #   };
      #   modules = [
      #     ./hosts/raspberrypi.nix
      #   ];
      # };

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs username;
        };
        modules = [
          ./configuration.nix

          {
            # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md#default-configuration--who-needs-configuration
            # NixOS configuration.
            nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
          }
          inputs.stylix.nixosModules.stylix # provide theming for system level programs such as bootloaders, splash screens, and display managers
          inputs.sops-nix.nixosModules.sops
          {
            imports = [ inputs.agenix.nixosModules.default ];
            environment.systemPackages = [ inputs.agenix.packages.${system}.default ];
          }
          inputs.niri.nixosModules.niri
          inputs.nixos-cli.nixosModules.nixos-cli
          inputs.catppuccin.nixosModules.catppuccin
          { environment.systemPackages = [ inputs.fh.packages.${system}.default ]; }

          inputs.nixos-cosmic.nixosModules.default
          # inputs.nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen7
          # inputs.sops-nix.nixosModules.sops
          (
            { ... }:
            {
              # stylix.enable = true;

              # stylix.targets.console.enable = true; # Linux kernel console
            }
          )
          { environment.systemPackages = [ inputs.nix-melt.packages.${system}.default ]; }
        ];
      };

      homeConfigurations = {
        "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs username system;
          };
          modules = [
            ./home
            {

              home.username = username;
              home.homeDirectory = "/home/" + username;
              # TODO: sync with `configuration.nix`
              home.stateVersion = "24.05";
              home.enableDebugInfo = false;

              # Let Home Manager install and manage itself.
              programs.home-manager.enable = true;
              nixpkgs.config.allowUnfree = true;
              nixpkgs.config.permittedInsecurePackages = [
                "olm-3.2.16"
                "electron-27.3.11"
                # "electron-29.4.6"
                # "electron-28.3.3" # needed for `logseq` 05-07-2024
                # "electron-27.3.11"
              ];
            }
            (
              { config, ... }:
              let
                cfg = config.catppuccin;
              in
              {
                imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
                config.catppuccin.enable = true; # Enable for all available programs you're using!
                config.catppuccin.flavor = "mocha";
                config.catppuccin.accent = "lavender";

                options.flavor = pkgs.lib.mkOption { type = pkgs.lib.types.attrs; };

                config.flavor = pkgs.lib.mkIf cfg.enable (
                  (pkgs.lib.importJSON (config.catppuccin.sources.palette + "/palette.json"))
                  .${config.catppuccin.flavor}.colors
                );
              }
            )
            {
              imports = [ inputs.stylix.homeManagerModules.stylix ];
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

            inputs.nix-index-database.hmModules.nix-index
            # optional to also wrap and install comma
            { programs.nix-index-database.comma.enable = true; }
            # { home.packages = [ inputs.zen-browser.packages.${system}.default ]; }
          ];
        };
      };
    };
}
