{
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
  };

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
          ];
        };
      };
    };
}
