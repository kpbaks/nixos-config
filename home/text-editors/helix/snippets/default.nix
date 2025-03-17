{
  pkgs,
  ...
}:
let
  generate-snippets =
    snippet-specs:
    let
      inherit (builtins) mapAttrs attrValues foldl';
      toml-format = pkgs.formats.toml { };
      extend = a: b: a // b;
      snippets-for-language = name: snippets: {
        xdg.configFile."helix/snippets/${name}.toml".source = toml-format.generate "helix-snippts-${name}" {
          snippets = map (snippet: snippet // { scope = name; }) snippets;
        };
      };
    in
    foldl' extend { } (attrValues (mapAttrs snippets-for-language snippet-specs));
in

generate-snippets {
  "cpp" = import ./cpp.nix;
  # "d2" = [ ];
  "fish" = import ./fish.nix;
  # "go" = [ ];
  # "nix" = [ ];
  "python" = import ./python.nix;
  "rust" = import ./rust.nix;
}
