# nixos-generate -f sd-image-raspberrypi -I nixpkgs=channels:nixos-unstable -c configuration.nix
{
  config,
  nixpkgs,
  pkgs,
  ...
}: {
  #imports = ["${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"];

  boot = {
    supportedFilesystems = ["nfs"];
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
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

  hardware.enableRedistributableFirmware = true;

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "superion";
    useDHCP = true;
    wireless.enable = false;
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
