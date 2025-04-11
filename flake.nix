{
  description = "@kpbaks' NixOS and home-manager configuration";

  # TODO(learn): what is the difference between `*` and `extra-*` options?
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = [
      "https://nix-community.cachix.org"
      # "https://insane.cachix.org"
      "https://cachix.cachix.org"
      # "https://hyprland.cachix.org"
      "https://helix.cachix.org"
      "https://yazi.cachix.org"
      "https://cosmic.cachix.org/"
      # "https://cache.garnix.io" # used by `ironbar`
      "https://watersucks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "insane.cachix.org-1:cLCCoYQKkmEb/M88UIssfg2FiSDUL4PUjYj9tdo4P8o="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
    ];
  };

  inputs.pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  inputs.fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";

  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.zen-browser.url = "github:youwen5/zen-browser-flake";
  inputs.zen-browser.inputs.nixpkgs.follows = "nixpkgs";

  # inputs.steel.url = "github:mattwparas/steel";
  # inputs.steel.inputs.nixpkgs.follows = "nixpkgs";

  # inputs.neovim-nightly-overlay = {
  #   url = "github:nix-community/neovim-nightly-overlay";
  #   inputs.nixpkgs.follows = "nixpkgs";
  # };
  # inputs.nixvim = {
  #   url = "github:nix-community/nixvim";
  #   # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
  #   # url = "github:nix-community/nixvim/nixos-24.11";

  #   inputs.nixpkgs.follows = "nixpkgs";
  # };

  # inputs.television.url = "github:alexpasmantier/television";
  # inputs.television.inputs.nixpkgs.follows = "nixpkgs";

  # inputs.nix-weather.url = "github:cafkafk/nix-weather";
  # inputs.nix-weather.inputs.nixpkgs.follows = "nixpkgs";

  inputs.ghostty = {
    url = "git+ssh://git@github.com/ghostty-org/ghostty";
    # inputs.nixpkgs-stable.follows = "nixpkgs-unstable";
    # inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    inputs.nixpkgs-stable.follows = "nixpkgs";
    inputs.nixpkgs-unstable.follows = "nixpkgs";
  };

  # FIXME: why is no `nixos` binary available?
  # inputs.nixos-cli = {
  #   url = "github:water-sucks/nixos";
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

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # catppuccin.url = "github:catppuccin/nix";
    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

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
      ...
    }@inputs:
    let
      hostname = "nixos";
      username = "kpbaks";
      system = "x86_64-linux";
      for-all-systems = nixpkgs.lib.genAttrs [ system ];
      overlays = [
        # inputs.rust-overlay.overlays.default
        # inputs.hyprpanel.overlay
        (final: prev: { ghostty = inputs.ghostty.packages.${system}.default; })
        # inputs.wired-notify.overlays.default
        inputs.niri.overlays.niri
        # (final: prev: { woomer = inputs.woomer.packages.${system}.default; })
        # inputs.swww.overlays.default
        # (final: prev: { swww = inputs.swww.packages.${prev.system}.swww; })
        # (final: prev: { zjstatus = inputs.zjstatus.packages.${prev.system}.default; })
        inputs.yazi.overlays.default
        inputs.helix.overlays.default
        # (final: prev: { television = inputs.television.packages.${prev.system}.default; })
        # inputs.neovim-nightly-overlay.overlay
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
        config.allowBroken = false;
      };
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;

      checks = for-all-systems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true;
            # deadnix.enable = true;
            flake-checker.enable = true;
            statix.enable = true;
            check-toml.enable = true;
            check-json.enable = true;
            check-yaml.enable = true;
            lychee.enable = true;
            typos.enable = true;
            # trufflehog.enable = true;
          };
        };
      });

      devShells = for-all-systems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
          packages = with pkgs; [
            update-nix-fetchgit
          ];
        };

      });

      # TODO: setup raspberrypi
      # TODO: setup nextcloud
      nixosConfigurations."raspberry-pi" = nixpkgs.lib.nixosSystem {
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

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs username;
        };
        modules = [
          ./configuration.nix
          # ./k3s.nix
          {
            # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md#default-configuration--who-needs-configuration
            # NixOS configuration.
            nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
          }
          # inputs.stylix.nixosModules.stylix # provide theming for system level programs such as bootloaders, splash screens, and display managers
          # inputs.sops-nix.nixosModules.sops
          # {
          #   imports = [ inputs.agenix.nixosModules.default ];
          #   environment.systemPackages = [ inputs.agenix.packages.${system}.default ];
          # }
          inputs.niri.nixosModules.niri
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
          { environment.systemPackages = [ inputs.fh.packages.${system}.default ]; }

          # {
          #   imports = [
          #     inputs.nixos-cosmic.nixosModules.default
          #   ];
          #   services.desktopManager.cosmic.enable = true;
          #   services.displayManager.cosmic-greeter.enable = true;
          # }
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
              ];
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

            {
              imports = [
                inputs.nix-index-database.hmModules.nix-index
              ];
              programs.nix-index-database.comma.enable = true;
            }
            { home.packages = [ inputs.zen-browser.packages.${system}.default ]; }
            # { home.packages = [ inputs.steel.packages.${system}.default ]; }
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
    };
}
