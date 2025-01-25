{ config, pkgs, ... }:
{
  # programs.aerc.enable = true;

  home.packages = with pkgs; [
    birdtray
    thunderbird # email client
  ];

  # programs.thunderbird.enable = true;
  # programs.thunderbird.package = pkgs.thunderbird;
  # programs.thunderbird.settings = {
  #   "general.useragent.override" = "";
  #   "privacy.donottrackheader.enabled" = true;
  # };

  # programs.thunderbird.profiles.personal = {
  #   name = "personal";
  #   isDefault = true;
  #   userContent = # css
  #     ''
  #       /* Hide scrollbar on Thunderbird pages */
  #       *{scrollbar-width:none !important}
  #     '';
  # };

  # TODO: get to work
  accounts.email.accounts = {
    gmail = {
      address = "kristoffer.pbs@gmail.com";
      realName = "Kristoffer Plagborg Bak Sørensen";
      primary = true;
      flavor = "gmail.com";
      # passwordCommand = pkgs.writeScript "gmail-password" "${pkgs.kdialog}/bin/kdialog --password 'gmail password'";
      passwordCommand = "${pkgs.kdialog}/bin/kdialog --password 'gmail password'";
      himalaya.enable = config.programs.himalaya.enable;

      #       [accounts.gmail]
      # email = "example@gmail.com"

      # folder.aliases.inbox = "INBOX"
      # folder.aliases.sent = "[Gmail]/Sent Mail"
      # folder.aliases.drafts = "[Gmail]/Drafts"
      # folder.aliases.trash = "[Gmail]/Trash"

      # backend.type = "imap"
      # backend.type.host = "imap.gmail.com"
      # backend.type.port = 993
      # backend.type.login = "example@gmail.com"
      # backend.type.auth.type = "password"
      # backend.type.auth.raw = "*****"

      # message.send.backend.type = "smtp"
      # message.send.backend.host = "smtp.gmail.com"
      # message.send.backend.port = 465
      # message.send.backend.login = "example@gmail.com"
      # message.send.backend.auth.type = "password"
      # message.send.backend.auth.cmd = "*****"

      himalaya.settings = {

      };
      thunderbird.enable = config.programs.thunderbird.enable;

      aerc.enable = config.programs.aerc.enable;
    };
    work = {

      #     [accounts.outlook]
      # email = "example@outlook.com"

      # backend.type = "imap"
      # backend.host = "outlook.office365.com"
      # backend.port = 993
      # backend.login = "example@outlook.com"
      # backend.auth.type = "password"
      # backend.auth.raw = "*****"

      # message.send.backend.type = "smtp"
      # message.send.backend.host = "smtp-mail.outlook.com"
      # message.send.backend.port = 587
      # message.send.backend.encryption.type = "start-tls"
      # message.send.backend.login = "example@outlook.com"
      # message.send.backend.auth.type = "password"
      # message.send.backend.auth.raw = "*****"

      address = "kristoffer.plagborgbak.soerensen@beumer.com";
      realName = "Kristoffer Plagborg Bak Sørensen";
      primary = false;
      flavor = "outlook.office365.com";
      # passwordCommand = pkgs.writeScript "gmail-password" "${pkgs.kdialog}/bin/kdialog --password 'gmail password'";
      passwordCommand = "${pkgs.kdialog}/bin/kdialog --password 'outlook password'";
      himalaya.enable = config.programs.himalaya.enable;
    };
  };

  programs.himalaya = {
    enable = false;
    settings = {
      # notify_cmd =
      #   pkgs.writeScript "mail-notifier" # sh
      #     ''
      #       SENDER="$1"
      #       SUBJECT="$2"
      #       ${pkgs.libnotify}/bin/notify-send -c himalaya "$(printf 'Received email from %s\n\n%s' "$SENDER" "$SUBJECT")"
      #     '';
    };
  };
  # services.himalaya-watch.enable = config.programs.himalaya.enable;
  services.himalaya-watch.enable = false;

  # FIXME: get to work under wayland and nixos
  # systemd.user.services.birdtray = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service.ExecStart = "${pkgs.birdtray}/bin/birdtray";
  # };
}
