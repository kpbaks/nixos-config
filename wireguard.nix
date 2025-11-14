{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.wireguard.enable = true;
  networking.wg-quick = {
    # enable = true;
    interfaces = {
      wg0 = {
        # ips = [ "10.13.13.4" ];
        address = [ "10.13.13.4" ];
        listenPort = 51820;
        privateKey = "uD8NAN5oetNasxphjQsbIu898KkLk88O+9YOxhH2VEQ=";
        dns = [
          "1.1.1.1"
          # "8.8.8.8"
        ];

        peers = [
          {
            publicKey = "K4bbRS1AZsfjBQZ+fRTPJTnlrW1HIbBK2hxGkKzQW1g=";
            presharedKey = "dHZYDa97A6Fz+D8NRSlkyPWHpe3uALmk4p9dxB/nMEw=";
            allowedIPs = [
              "0.0.0.0/0"
              "192.168.0.0/24"
            ];
            endpoint = "vpn.unincorporated.dev:51820";
          }
        ];
      };
    };
  };

  #   [Interface]
  # Address = 10.13.13.4
  # PrivateKey = uD8NAN5oetNasxphjQsbIu898KkLk88O+9YOxhH2VEQ=
  # ListenPort = 51820
  # DNS = 1.1.1.1

  # [Peer]
  # PublicKey = K4bbRS1AZsfjBQZ+fRTPJTnlrW1HIbBK2hxGkKzQW1g=
  # PresharedKey = dHZYDa97A6Fz+D8NRSlkyPWHpe3uALmk4p9dxB/nMEw=
  # Endpoint = vpn.unincorporated.dev:51820
  # AllowedIPs = 0.0.0.0/0, 192.168.0.0/24

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
