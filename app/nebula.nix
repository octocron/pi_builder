{
  config,
  lib,
  ...
}: {
  services.nebula = {
    enable = true;
    ca = "/etc/nebula/ca.crt";
    cert = "/etc/nebula/satisfactory.crt";
    key = "/etc/nebula/satisfactory.key";
    lighthouse = {
      enable = false; # Set to true if this is a lighthouse
      hosts = ["192.168.100.2"]; # IP of lighthouse
    };
    staticHostMap = {
      "192.168.100.2" = ["lighthouse.example.com:4242"];
    };
    tun = {
      device = "nebula1";
      mtu = 1300;
    };
    firewall = {
      outbound = ["allow any"];
      inbound = ["allow any"];
    };
    listen = {
      host = "0.0.0.0";
      port = 4242;
    };
  };

  # Ensure nebula directory exists
  # NOTE: create nebula folder without blowing it away, that's the -
  systemd.tmpfiles.rules = [
    "d /etc/nebula 0755 root root -"
  ];

  # If using sops for secrets, uncomment and adjust
  # NOTE: Signs other certs (Master Cert)
  # sops.secrets."nebula/ca" = {
  #   path = "/etc/nebula/ca.crt";
  # };
  # NOTE: Cert allows host on the network
  # sops.secrets."nebula/cert" = {
  #   path = "/etc/nebula/satisfactory.crt";
  # };
  # NOTE: Passphrase for creating the encryption on the tun
  # sops.secrets."nebula/key" = {
  #   path = "/etc/nebula/satisfactory.key";
  #   mode = "0600";
  # };
}
