# Cool julia packages:
# - https://github.com/JuliaPlots/UnicodePlots.jl

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # https://github.com/NixOS/nixpkgs/blob/1e99a1a49dcade284081fd3349e294e9badc9ba1/doc/languages-frameworks/julia.section.md#juliawithpackages-julia-withpackage
    ((julia.withPackages.override { precompile = true; }) [
      # "Plots"
      # "Pluto"
      # "Revise"
      "OhMyREPL"
    ])
    # julia
    # julia-lts
    # julia-stable
  ];

  # sourced every time the `julia` is started
  home.file.".julia/config/startup.jl".text =
    let
      startup-packages = [
        # "Revise"
        "LinearAlgebra" # builtin
        "Statistics" # builtin
        "Random" # builtin
        "OhMyREPL"
      ];
    in
    # julia
    ''
      ${pkgs.lib.concatStringsSep "\n" (map (pkg: "using ${pkg}") startup-packages)}

      atreplinit() do repl
        println("loaded:")
        for pkg in [${pkgs.lib.concatStringsSep ", " (map (pkg: ''"${pkg}"'') startup-packages)}]
          println(" - $pkg")
        end
      end
    '';
  # https://timholy.github.io/Revise.jl/stable/config/#Using-Revise-automatically-within-Jupyter/IJulia
  home.file."julia/config/startup_ijulia.jl".text =
    # julia
    ''
      try
          @eval using Revise
      catch e
          @warn "Error initializing Revise" exception=(e, catch_backtrace())
      end
    '';

  # https://timholy.github.io/Revise.jl/stable/config/#Manual-revision:-JULIA_REVISE
  home.sessionVariables.JULIA_REVISE = "auto"; # "auto" | "manual"
}
