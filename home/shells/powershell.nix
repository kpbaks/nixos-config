# TODO: install this for helix https://github.com/PowerShell/PowerShellEditorServices
{
  config,
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    powershell
  ];

  programs.vscode.profiles.default.extensions =
    let
      extensions = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system};
    in
    with extensions.vscode-marketplace;
    [
      ms-vscode.powershell
      # ironmansoftware.powershellprotools
      # TylerLeonhardt.vscode-inline-values-powershell
    ];

  xdg.configFile."powershell/Microsoft.PowerShell_profile.ps1".text =

    # powershell
    ''
      function which($name) {
        get-command $name | select-object -ExpandProperty Definition
      }

      function follow($file) {
        get-content $file -wait
      }

      import-module -Name PSReadLine -Scope Global
    ''
    + (
      if config.programs.starship.enable then
        # powershell
        ''
          # function Invoke-Starship-TransientFunction {
          #   &starship module character
          # }

          # Invoke-Expression (&starship init powershell)

          # Enable-TransientPrompt
                
        ''
      else
        ""
    );

}
