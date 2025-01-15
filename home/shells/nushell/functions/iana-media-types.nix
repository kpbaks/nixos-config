{ pkgs, ... }:
{

  programs.nushell.extraConfig = # nu
    ''

      		def "iana media-types" [] {
      			# https://www.iana.org/assignments/media-types/media-types.xhtml
      		}
      	'';
}
