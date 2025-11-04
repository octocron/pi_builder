{
  pkgs,
  lib,
  ...
}: {
  virtualisation = {
    oci-containers = {
      backend = "podman";
      containers = {
        homeassistant = {
          volumes = ["home-assistant:/config"];
          environment.TZ = "America/New_York";
          image = "ghcr.io/home-assistant/home-assistant:stable";
          extraOptions = [
            "--network=host"
            "--device=/dev/ttyACM0:/dev/ttyAMC0" # path to zigbee USB device
          ];
        };
      };
    };

    podman = {
      enable = true;
      autoPrune = {
        enable = true;
        flags = ["--all"];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [8123];

  systemd = {
    timers = {
      update-containers = {
        wantedBy = ["timers.target"];
        timerConfig = {
          Unit = "update-containers.service";
          OnCalendar = "Sat 06:00";
        };
      };
      restart-homeassistant = {
        wantedBy = ["timers.target"];
        timerConfig = {
          Unit = "update-containers.service";
          OnCalendar = "Sat 06:20";
        };
      };
    };

    # sudo systemctl restart update-containers.service to trigger manually
    services = {
      update-containers = {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = lib.getExe (
            pkgs.writeShellScriptBin "update-containers" ''
              images=$(${pkgs.podman}/bin/podman ps -a --format="{{.Image}}" | sort -u)

              for image in $images; do
              ${pkgs.podman}/bin/podman pull $image
              done
            ''
          );
        };
      };
      restart-homeassistant = {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.systemd}/bin/systemctl try-restart podman-homeassistant.service";
        };
      };
    };
  };
}
