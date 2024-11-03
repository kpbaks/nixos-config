{
  config,
  lib,
  pkgs,
  ...
}:
let
  gh = lib.getExe config.programs.gh.package;
  script =
    pkgs.writers.writeNuBin "my-forks" { }
      # nu
      ''
        let fields = "primaryLanguage,url,licenseInfo,nameWithOwner,createdAt,parent,updatedAt,description"
        ${gh} repo list --fork --limit 9999 --json $fields
        | ansi strip
        | from json
        | rename --block { str kebab-case }
        | update primary-language { |row| $row.primary-language | get name }
        | update license-info { |row| $row.license-info | get key }
        | rename --column { license-info: license }
        | update updated-at { into datetime }
        | update created-at { into datetime }
        | rename name-with-owner name
        | columns
        # | update name { |row| $row.url | ansi link --text $row.name }
        # | reject url
      '';
in
{
  home.packages = [ script ];
}
