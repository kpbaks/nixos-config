{ pkgs, inputs, ... }:
{
  # FIXME: why are these not in $PATH $out/bin/{qs,quickshell}
  home.packages = [
    inputs.quickshell.packages.${pkgs.system}.default
    # (inputs.quickshell.packages.${pkgs.system}.default.override {
    #   withJemalloc = true;
    #   withQtSvg = true;
    #   withWayland = true;
    #   withX11 = false;
    #   withPipewire = true;
    #   withPam = true;
    #   withHyprland = false;
    # })

    pkgs.kdePackages.qtdeclarative # for `qmlformat`, `qmllint`, `qmlls`
  ];
}
