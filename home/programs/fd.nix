{
  programs.fd = {
    enable = true;
    ignores = [
      ".git/"
      "*.bak"
    ];
    hidden = true;
    extraOptions = [
      # "--absolute-path"
    ];
  };
}
