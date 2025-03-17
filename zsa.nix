{
  pkgs,
  ...
}:
{
  # For my ZSA Moonlander keyboard
  hardware.keyboard.zsa.enable = true;

  environment.systemPackages = with pkgs; [
    keymapp
    kontroll
  ];
}
