{
  description = "@kpbaks' NixOS configuration";

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
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };
    # TODO: use
    sops-nix.url = "github:Mic92/sops-nix";
    # TODO: use
    nur.url = "github:nix-community/NUR";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-completion-language-server.url = "github:estin/simple-completion-language-server";
    # TODO: use
    yazi.url = "github:sxyazi/yazi";
    catppuccin.url = "github:catppuccin/nix";
    # TODO: use
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    # TODO: use
    stylix.url = "github:danth/stylix";
    # TODO: use
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";

    # TODO: use
    ags.url = "github:Aylur/ags";
    # atdo.url = "github:kpbaks/atdo";
    # atdo.inputs.nixpkgs.follows = "nixpkgs";
    swww.url = "github:LGFae/swww";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    hostname = "nixos";
    username = "kpbaks";
    system = "x86_64-linux";
    # system = builtins.currentSystem;
    overlays = [
      inputs.niri.overlays.niri
      # inputs.neovim-nightly-overlay.overlay
    ];
    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
    # pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      # nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        # inputs.stylix.nixosModules.stylix
        inputs.niri.nixosModules.niri
        inputs.sops-nix.nixosModules.sops
      ];
    };

    homeConfigurations = {
      "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs username;};
        modules = [
          ./home.nix
          inputs.niri.homeModules.niri
          inputs.anyrun.homeManagerModules.default
          inputs.catppuccin.homeManagerModules.catppuccin
          inputs.plasma-manager.homeManagerModules.plasma-manager
          (
            {...}: {
              catppuccin.flavor = "macchiato";
              catppuccin.accent = "lavender";
            }
          )
          # inputs.anyrun.homeManagerModules.default
          # (
          #   {...}: {
          #     home.packages = [inputs.yazi.packages.${pkgs.system}.default];
          #   }
          # )
        ];
      };
    };
  };
}
