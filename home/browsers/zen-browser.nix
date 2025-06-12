{ inputs, pkgs, ... }:
{
  # TODO: enable "text-fragments" https://developer.mozilla.org/en-US/docs/Web/URI/Fragment/Text_fragments
  # pref("dom.text_fragments.enabled", true);

  home.packages = [ inputs.zen-browser.packages.${pkgs.system}.default ];

}
