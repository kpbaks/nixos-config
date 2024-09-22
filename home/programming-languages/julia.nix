{ pkgs, ... }:
{

  home.packages = with pkgs; [ julia ];

  # sourced every time the `julia` is started
  home.file.".julia/config/startup.jl".text =
    let
      startup-packages = [
        "LinearAlgebra"
        "Statistics"
        "Random"
        # "OhMyREPL"
      ];
    in
    ''
      ${pkgs.lib.concatStringsSep "\n" (map (pkg: "using ${pkg}") startup-packages)}

      atreplinit() do repl
        println("loaded:")
        for pkg in [${pkgs.lib.concatStringsSep ", " (map (pkg: ''"${pkg}"'') startup-packages)}]
          println(" - $pkg")
        end
      end
    '';
}
