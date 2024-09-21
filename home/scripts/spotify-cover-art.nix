{ pkgs, ... }:

pkgs.writers.writeNuBin "spotify-cover-art" { }
  # nu
  ''
    try {
      let art_url = (${pkgs.playerctl}/bin/playerctl -p spotify metadata mpris:artUrl)
      if $env.KITTY_PID? != null {
        http get --raw $art_url | kitten icat 
      }
    } catch {
      
    }
  ''
