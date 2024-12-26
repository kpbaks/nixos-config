{ pkgs, ... }:
{

  options.personal =
    let
      inherit (pkgs.lib) mkOption types;
      str = mkOption { type = types.str; };
      package = mkOption { type = types.package; };
      int = mkOption { type = types.int; };
    in
    {
      name = str;
      full-name = str;
      age = int;
      gmail = str;
      aumail = str;
      tutamail = str;
      email = str;
      telephone-number = str;
      terminal = package;

    };
  config.personal = rec {
    name = "Kristoffer Sørensen";
    full-name = "Kristoffer Plagborg Bak Sørensen";
    age = 25; # TODO: compute this from my birthday
    gmail = "kristoffer.pbs@gmail.com";
    aumail = "201908140@post.au.dk";
    tutamail = "kristoffer.pbs@tuta.io";
    email = gmail;
    telephone-number = "21750049";

    # city = "Aarhus";
    # country = "Denmark";
    # continent = "Europa";
  };
}
