{ ... }:
{

  # TODO: save user settings for jupyter lab
  # TODO: figure out how to install extensions on nixos
  # ~/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/notification.jupyterlab-settings

  # TODO: use https://github.com/jupyter-lsp/jupyterlab-lsp
  # TODO: use https://github.com/catppuccin/jupyterlab

  # home.file.".jupyter/lab/user-settings/@jupyterlab/apputils-extension/notification.jupyterlab-settings".text = "";
  # home.file."~/.jupyter/lab/user-settings/@jupyterlab/completer-extension/inline-completer.jupyterlab-settings".text =
  #   builtins.toJSON
  #   {
  #     providers = {
  #       "@jupyterlab/inline-completer:history" = {
  #         debouncerDelay = 0;
  #         enabled = true;
  #         maxSuggestions = 100;
  #         timeout = 5000;
  #       };
  #     };
  #     showShortcuts = true;
  #     showWidget = "always";
  #     streamingAnimation = "uncover";
  #   };

  # xdg.configFile."foo".text = ''fooo'';
  # builtins.toJSON;

  # home.file.".config/jupyter/...".text =
  #   /*
  #   json
  #   */
  #   ''

  #   '';
}
