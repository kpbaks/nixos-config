# TODO: submit as hm-module
# programs.hadolint.enable
# programs.hadolint.settings
# programs.hadolint.opencontainersLabels = true
{ pkgs, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
in
{
  home.packages = with pkgs; [ hadolint ];

  xdg.configFile."hadolint.yaml".source = yamlFormat.generate "hadolint-config" {
    strict-labels = false;
    # trustedRegistries = [ "docker.io" ];
    # https://github.com/hadolint/hadolint#linting-labels
    # https://specs.opencontainers.org/image-spec/annotations/?v=v1.0.1#pre-defined-annotation-keys
    # NOTE: the outcommented ones should be generated dynamically as part of the build
    # process from the project context
    label-schema = {
      "org.opencontainers.image.authors" = "text";
      "org.opencontainers.image.created" = "rfc3339";
      "org.opencontainers.image.description" = "text";
      "org.opencontainers.image.documentation" = "url";
      "org.opencontainers.image.licenses" = "spdx";
      # "org.opencontainers.image.ref.name" = "text";
      # "org.opencontainers.image.revision" = "hash";
      "org.opencontainers.image.source" = "url";
      "org.opencontainers.image.title" = "text";
      "org.opencontainers.image.url" = "url";
      "org.opencontainers.image.vendor" = "text";
      # "org.opencontainers.image.version" = "semver";
    };
  };
}
