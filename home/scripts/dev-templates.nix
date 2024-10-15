{ pkgs, ... }:
let
  script =
    pkgs.writers.writeNuBin "dev-templates" { }
      # nu
      ''
        def main [subcommand: string = "init"] {

          # TODO(pr): add support for roc-lang
          const url = "https://github.com/the-nix-way/dev-templates"
          let html = http get $url

          # TODO: make selector less direct, I got it from using the browser element selection tool.
          let css_selector = ".markdown-body > markdown-accessiblity-table:nth-child(11) > table:nth-child(1) td"
          let template_names = $html | ${pkgs.htmlq}/bin/htmlq --text $css_selector | lines | every 2 --skip

          match $subcommand {
            "init" => {}, # continue
            "list" => {
              $template_names
              exit 0
            },
            _ => {
              error make {
                msg: "Invalid subcommand",
                label: {
                  text: "Invalid subcommand. Valid subcommands are [init, list]"
                  span: (metadata $subcommand).span
                }
              }
            }
          }

          # https://raw.githubusercontent.com/the-nix-way/dev-templates/refs/heads/main/bun/flake.nix

          let selected_template_name = try {
            $template_names | ${pkgs.fzf}/bin/fzf
          } catch {
            exit
          }

          let flake_url = $"https://flakehub.com/f/the-nix-way/dev-templates/*#($selected_template_name)"
          nix flake init --template $flake_url
        }
      '';
in
{
  home.packages = [ script ];

}
