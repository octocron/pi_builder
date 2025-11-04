# NOTE: Run for Setup to establish key connection:
# sudo mkdir -p /etc/tailscale
# echo "<tskey-auth-replace>" | sudo tee /etc/tailscale/tskey-reusable
# sudo chmod 600 /etc/tailscale/tskey-reusable
# sudo chmod 700 /etc/tailscale
{pkgs, ...}: {
  services.tailscale = {
    enable = true;
    openFirewall = false; # avoid misleading expectations in WSL
    useRoutingFeatures = "client"; # server = exit node, client use tailnet, both = client + server
    extraUpFlags = [
      "--accept-dns=true" # magicDNS (not for server - exit node)
      "--accept-routes"
      "--hostname=satisfactory"
      "--userspace-networking"
      #"--advertise-routes=0.0.0.0/0" # optional, only if you intend to be exit node
      #"--login-server=https://your-instance" # if you use a non-default login server
    ];
  };

  networking = {
    #firewall.allowedUDPPorts = [config.services.tailscale.port]; # only needed on real Linux, not WSL
    useDHCP = true; # required for WSL2 networking
  };

  environment = {
    systemPackages = with pkgs; [
      tailscale
      jq
    ];
  };

  systemd = {
    tmpfiles.rules = [
      "d /etc/tailscale 0755 root root -"
    ];
    services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";
      wantedBy = ["multi-user.target"];
      after = [
        "network-pre.target"
        "tailscale.service"
      ];
      wants = [
        "network-pre.target"
        "tailscale.service"
      ];

      serviceConfig = {
        Type = "oneshot";
        Environment = "TS_USE_USERSPACE_NETWORKING=true";
      };

      script = with pkgs; ''
        echo "Waiting for tailscale.service start completion ..."
        sleep 5

        echo "Checking if already authenticated to Tailscale ..."
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ "$status" = "Running" ]; then
          echo "Already authenticated to Tailscale, exiting."
          exit 0
        fi

        echo "Authenticating with Tailscale ..."
        ${tailscale}/bin/tailscale up --auth-key file:/etc/tailscale/tskey-reusable
      '';
    };
  };
}
