{
  description = "@kpbaks' NixOS configuration";

  inputs = {
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    # home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    yazi.url = "github:sxyazi/yazi";
    catppuccin.url = "github:catppuccin/nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    helix.url = "github:helix-editor/helix";

    # anyrun.url = "github:Kirottu/anyrun";
    # anyrun.inputs.nixpkgs.follows = "nixpkgs";
    # TODO: use in home.nix
    # atdo.url = "github:kpbaks/atdo";
    # atdo.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/estin/simple-completion-language-server/blob/main/flake.nix
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    yazi,
    catppuccin,
    helix,
    # anyrun,
    ...
  } @ inputs: let
    HOSTNAME = "nixos";
    USER = "kpbaks";
    system = "x86_64-linux";
    overlays = [
      inputs.neovim-nightly-overlay.overlay
    ];
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.${HOSTNAME} = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [./configuration.nix];
    };
    homeConfigurations = {
      "${USER}@${HOSTNAME}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          # catppuccin.homeManagerModules.catppuccin
          ./home.nix
          # (
          #   # TODO: verify this works
          #   {pkgs, ...}: {
          #     home.packages = [yazi.packages.${pkgs.system}.default];
          #   }
          # )
        ];
      };
    };
  };
}
