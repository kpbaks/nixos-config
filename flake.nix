{
  description = "@kpbaks' NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    simple-completion-language-server.url = "github:estin/simple-completion-language-server";
    yazi.url = "github:sxyazi/yazi";
    catppuccin.url = "github:catppuccin/nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    helix.url = "github:helix-editor/helix";
    stylix.url = "github:danth/stylix";
    # TODO: use in home.nix
    # niri.url =  "https://github.com/sodiboo/niri-flake";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    ags.url = "github:Aylur/ags";
    # atdo.url = "github:kpbaks/atdo";
    # atdo.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    # yazi,
    # catppuccin,
    # helix,
    # anyrun,
    ...
  } @ inputs: let
    HOSTNAME = "nixos";
    USER = "kpbaks";
    system = "x86_64-linux";
    overlays = [
      # inputs.neovim-nightly-overlay.overlay
    ];
    pkgs = import nixpkgs {
      inherit system overlays;
    };
    # pkgs = nixpkgs.legacyPackages.${system};
  in {
    # nixosConfigurations.${HOSTNAME} = nixpkgs.lib.nixosSystem {
    #   inherit system;
    #   modules = [./configuration.nix];
    # };
    homeConfigurations = {
      "${USER}@${HOSTNAME}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./home.nix
          # inputs.stylix.homeManagerModules.stylix
          inputs.catppuccin.homeManagerModules.catppuccin
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
