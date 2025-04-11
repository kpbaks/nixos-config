{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: propose upstream for inclusion into home-manager
  # NOTE: idea already proposed before, but rejected as not planned https://github.com/nix-community/home-manager/issues/5218
  home.activation.helix-fetch-and-build-grammars =
    let
      hx = lib.getExe config.programs.helix.package;
    in
    lib.hm.dag.entryAfter [ "linkGeneration" ]
      # bash
      ''
        # TODO: what if the runtime folder does not exist?
        export HELIX_RUNTIME=${config.xdg.configHome}/helix/runtime
        export PATH="${config.programs.git.package}/bin/:$PATH"
        # NOTE: `g++` compiler is used to compile tree-sitter C code
        export PATH="${pkgs.gcc}/bin:$PATH"
        verboseEcho "Fetching tree-sitter grammars"
        run ${hx} --grammar fetch
        verboseEcho "Building tree-sitter grammars"
        run ${hx} --grammar build
      '';
}
