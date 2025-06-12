{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.git.mergiraf;
in
{
  options.programs.git.mergiraf.enable = lib.mkEnableOption "mergiraf";
  config = lib.mkIf cfg.enable {
    # TODO: have a .package option
    home.packages = [ pkgs.mergiraf ];

    programs.git = {
      extraConfig = {
        merge.mergiraf = {
          name = "mergiraf";
          driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
        };
      };
      attributes = [
        "* merge=mergiraf"
        # `nix run nixpkgs#mergiraf -- languages --gitattributes`
        # "*.java merge=mergiraf"
        # "*.properties merge=mergiraf"
        # "*.kt merge=mergiraf"
        # "*.rs merge=mergiraf"
        # "*.go merge=mergiraf"
        # "*.js merge=mergiraf"
        # "*.jsx merge=mergiraf"
        # "*.mjs merge=mergiraf"
        # "*.json merge=mergiraf"
        # "*.yml merge=mergiraf"
        # "*.yaml merge=mergiraf"
        # "*.toml merge=mergiraf"
        # "*.html merge=mergiraf"
        # "*.htm merge=mergiraf"
        # "*.xhtml merge=mergiraf"
        # "*.xml merge=mergiraf"
        # "*.c merge=mergiraf"
        # "*.h merge=mergiraf"
        # "*.cc merge=mergiraf"
        # "*.hh merge=mergiraf"
        # "*.cpp merge=mergiraf"
        # "*.hpp merge=mergiraf"
        # "*.cxx merge=mergiraf"
        # "*.hxx merge=mergiraf"
        # "*.c++ merge=mergiraf"
        # "*.h++ merge=mergiraf"
        # "*.mpp merge=mergiraf"
        # "*.cppm merge=mergiraf"
        # "*.ixx merge=mergiraf"
        # "*.tcc merge=mergiraf"
        # "*.cs merge=mergiraf"
        # "*.dart merge=mergiraf"
        # "*.dts merge=mergiraf"
        # "*.scala merge=mergiraf"
        # "*.sbt merge=mergiraf"
        # "*.ts merge=mergiraf"
        # "*.tsx merge=mergiraf"
        # "*.py merge=mergiraf"
        # "*.php merge=mergiraf"
        # "*.phtml merge=mergiraf"
        # "*.sol merge=mergiraf"
        # "*.lua merge=mergiraf"
        # "*.rb merge=mergiraf"
        # "*.nix merge=mergiraf"
        # "*.sv merge=mergiraf"
        # "*.svh merge=mergiraf"
      ];
    };
  };

}
