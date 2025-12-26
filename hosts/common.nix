{ pkgs, ... }:
let
  theLocale = "en_US.UTF-8";
  theTimezone = "America/New_York";
  username = "megacron";
in
{
  #------------------LOCALIZATION-----------------------#
  console.keyMap = "us";
  time.timeZone = "${theTimezone}";
  i18n = {
    defaultLocale = "${theLocale}";
    extraLocaleSettings = {
      LC_ADDRESS = "${theLocale}";
      LC_IDENTIFICATION = "${theLocale}";
      LC_MEASUREMENT = "${theLocale}";
      LC_MONETARY = "${theLocale}";
      LC_NAME = "${theLocale}";
      LC_NUMERIC = "${theLocale}";
      LC_PAPER = "${theLocale}";
      LC_TELEPHONE = "${theLocale}";
      LC_TIME = "${theLocale}";
    };
  };

  #------------------FONTS-SYSTEM-WIDE------------------#
  fonts.packages = with pkgs; [
    maple-mono.opentype
    nerd-fonts.symbols-only
  ];

  #-----------------------NIX---------------------------#
  nix = {
    nrBuildUsers = 64;
    settings = {
      cores = 2; # 0 means all available cores
      warn-dirty = false;
      auto-optimise-store = true;
      download-buffer-size = 240 * 1024 * 1024;
      min-free = 10 * 1024 * 1024;
      max-free = 200 * 1024 * 1024;
      max-jobs = 4; # "auto" means all, 0 means use remote specified in builders
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [
        "root"
        "${username}"
        "@wheel"
      ];
      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
  };

  #-----------------------ALLOW-------------------------#
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # For when dangon devs use EOL dependencies, grrrr..
    ];
  };

  #-----------------------SECURITY-----------------------#
  security = {
    rtkit.enable = true;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "${username}" ];
          keepEnv = true;
          noPass = false;
        }
        {
          groups = [ "wheel" ];
          noPass = false; # Allows passwordless execution
        }
      ];
    };

    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if ( subject.isInGroup("users") && (
           action.id == "org.freedesktop.login1.reboot" ||
           action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
           action.id == "org.freedesktop.login1.power-off" ||
           action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          ))
          { return polkit.Result.YES; }
        })
      '';
    };

    # pam.services.swaylock = {
    #   text = ''auth include login '';
    # };

    sudo.extraConfig = ''
      Defaults      timestamp_timeout=1800
    '';
  };

  #-----------------------SYSTEMD------------------------#
  # optimise nix builders (keep from running out of memory)
  systemd = {
    extraConfig = "DefaultTimeoutStopSec=10s"; # give more time for services to shutdown gracefully
    services = {
      nix-daemon.serviceConfig = {
        MemoryAccounting = true;
        MemoryMax = "90%";
        OOMScoreAdjust = 500;
      };

      tailscale-autoconnect = {
        description = "Automatic connection to Tailscale";
        # make sure tailscale is running before trying to connect
        after = [
          "network-pre.target"
          "tailscale.service"
        ];
        wants = [
          "network-pre.target"
          "tailscale.service"
        ];
        wantedBy = [ "multi-user.target" ];
        # set this service as a oneshot job
        serviceConfig.Type = "oneshot";
        # have the job run this shell script
        script = with pkgs; ''
          # wait for tailscaled to settle
          sleep 2
          # check if we are already authenticated to tailscale
          status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then
            exit 0
          fi
          # otherwise authenticate with tailscale
          ${tailscale}/bin/tailscale up --authkey=tskey-auth-k9YCRHoYfR11CNTRL-x19aNr127p1JTay7JadSo1V8MiejMYM7U
        '';
      };
    };
  };
}
