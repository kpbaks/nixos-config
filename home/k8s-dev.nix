{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
    # kube-shell # TODO: package https://github.com/cloudnativelabs/kube-shell
    kompose
    kustomize
    kube-linter
    kubeconform
    conftest
    kubectx
    k3d
    skaffold
    argocd

    # argocd-autopilot
    stern # log viewer
    gonzo # log viewer
    # kubectl "plugins"
    kubectl-neat
    kubectl-tree
    # kubectl-node-resource # TODO: package https://github.com/ahmetb/kubectl-node_resource
    # kubectl-cond # TODO: package https://github.com/ahmetb/kubectl-cond
    # kubectl-fields # TODO: package https://github.com/ahmetb/kubectl-fields
    # kubectl-foreach # TODO: package https://github.com/ahmetb/kubectl-foreach
    # kl # TODO: package
    # kubediff # TODO: package
  ];

  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };

  home.shellAliases = {
    k = "kubectl";
  };

  programs.k9s = {
    enable = true;
    aliases = {
      # Use pp as an alias for Pod
      pp = "v1/pods";
    };
  };
}
