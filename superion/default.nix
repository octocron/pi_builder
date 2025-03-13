# nixos-generate -f sd-aarch64 -I nixpkgs=channel:nixos-unstable -c configuration.nix
{
  config,
  nixpkgs,
  pkgs,
  ...
}: {
  #imports = ["${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"];

  boot = {
    supportedFilesystems = ["nfs"];
    initrd = {
      network = {
        enable = true;
        flushBeforeStage2 = false;
      };
      availableKernelModules = [
        "bcm_phy_lib"
        "broadcom"
        "genet"
        "nfs"
        "overlay"
      ];
      kernelModules = [
        "bcm_phy_lib"
        "broadcom"
        "genet"
        "nfs"
        "overlay"
      ];
      supportedFilesystems = [
        "nfs"
        "overlay"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    nixos-generators
    openssh
    tmux
    xclip
    vim
    zsh
  ];

  fileSystems = {
    # boot section may not be needed since identical options exist in root
    "/boot/firmware" = {
      device = "192.168.1.87:/volume1/tftpboot/ae5b6631";
      fsType = "nfs";
      options = [
        "nolock"
        "rw"
        "vers=3"
        "rsize=131072"
        "wsize=131072"
        "namlen=255"
        "hard"
        "noacl"
        "proto=tcp"
        "timeo=11"
        "retrans=3"
        "sec=sys"
        "mountvers=3"
        "mountproto=tcp"
        "local_lock=all"
        "noatime"
        "nodiratime"
      ];
      neededForBoot = true;
    };
    "/" = {
      device = "192.168.1.87:/volume1/superion";
      fsType = "nfs";
      options = [
        "nolock"
        "rw"
        "vers=3"
        "rsize=131072"
        "wsize=131072"
        "namlen=255"
        "hard"
        "noacl"
        "proto=tcp"
        "timeo=11"
        "retrans=3"
        "sec=sys"
        "mountvers=3"
        "mountproto=tcp"
        "local_lock=all"
        "noatime"
        "nodiratime"
      ];
      neededForBoot = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "superion";
    useDHCP = true;
    wireless.enable = false;
    interfaces = {
      eth0.useDHCP = true;
      wlan0.useDHCP = false;
    };
  };

  nix = {
    settings = {
      accept-flake-config = true;
      experimental-features = ["flakes" "nix-command"];
      trusted-users = ["megacron"];
      warn-dirty = false;
    };
  };

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      config = [
        {
          delta = {
            enable = true;
            options = {
              light = false;
              line-numbers = true;
              navigate = true;
              side-by-side = true;
            };
          };
          user = {
            name = "megacron";
            email = "megacron@d3c3p7.com";
          };
          commit = {
            gpgsign = true;
            verbose = true;
          };
          gpg = {
            format = "ssh";
            ssh.allowedSignersFile = "~/.ssh/allowed_signers";
          };
          push = {
            default = "current";
            autoSetupRemote = true;
          };
          user.signingkey = "~/.ssh/id_ironhide";
        }
      ];
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    ssh = {
      extraConfig = ''
        addKeysToAgent yes
        IdentityFile ~/.ssh/id_ironhide
      '';
    };
  };

  services = {
    openssh.enable = true;
    printing.enable = false;
  };

  system = {
    stateVersion = "24.11";
  };

  time.timeZone = "America/New_York";

  users.users.megacron = {
    homeMode = "755";
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    hashedPassword = "$6$3IjpzOK5hW3qaugr$NZ4EX4pd9zqgFPO20LXD6xRCh6Xkj3/LRKVRZf8.qmxu.6zMVqqteff8QDRpSdmg9LOwFPRKjjtzInU9/xc8p1"; # mkpasswd -m sha-512
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCFpd0UZyX1T0WewVnzEWYY+9oXX+JcJaTLusO33/FX ansible"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPOPzh8vu5f8/T5IbbD6/1tzpnH94EPcta7FS2vUy45 optimus"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1ZJSRTAzfmHNMDLWHKEm1oCr82v8zYvoaMVAvIGZdp galvatron"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIYwMb4RRHkA0WL+TF9XtW54hqu4XrY2yLsF7b+9PCdY blackout.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPnQdwT0HIgx43nv37wrepEAn6BDeP0uxLT/KDKAHE/ energon"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBG++DllhoaxmTnSQ155B0dgEbRO+XHsXP8a3znDm8YesXYcct+cDvV1ysf7HEP/9jaQmrbOSXKtdC1bA3fYU4mk= drift"
    ];
  };
}
