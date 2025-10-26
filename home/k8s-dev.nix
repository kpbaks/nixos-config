{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
    kompose
    kustomize
    kube-linter
    kubeconform
    conftest
    kubectx
    # kubectl "plugins"
    kubectl-neat
  ];

  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };

  programs.k9s = {
    enable = true;
    aliases = {
      # Use pp as an alias for Pod
      pp = "v1/pods";
    };
  };
}
