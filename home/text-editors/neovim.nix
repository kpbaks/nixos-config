{ pkgs, ... }:
{
  programs.neovide.enable = false;

  # programs.neovim = {
  #   enable = false;
  #   defaultEditor = false;
  #   package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

  #   extraPackages = with pkgs; [
  #     gnumake
  #     tree-sitter
  #     nodejs # for copilot.lua
  #     marksman # markdown lsp
  #     libgit2 # c library to interact with git repositories, needed by fugit2.nvim plugin

  #     # nice for configuring neovim
  #     stylua # formatter
  #     selene # linter
  #     lua-language-server # lsp
  #     lua51Packages.lua
  #     libgit2
  #     luajit
  #     luajitPackages.luarocks
  #   ];
  # };
}
