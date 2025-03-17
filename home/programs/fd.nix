{
  programs.fd = {
    enable = true;
    ignores = [
      ".git/"
      "*.bak"
    ];
    hidden = true;
    extraOptions = [
      "--follow"
      "--hyperlink"
      # "--absolute-path"
    ];
  };
}
