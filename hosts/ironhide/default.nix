# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    hostName = "ironhide";
    wireless = {
      enable = true;
      networks = {
        "Multiplex" = {
          psk = "K8d41rye!$";
        };
        "FBIvan007" = {
          psk = "7989djwbeh";
        };
      };
    };
    #  interfaces.wlan0.useDHCP = true;
    #  nameservers = [ "9.9.9.9" "149.112.112.112" "8.8.8.8" "8.8.4.4" ];
    #  networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  };

  swapDevices = [
    {device = "/dev/disk/by-label/swap";}
  ];

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = false;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #  enable = true;
  #  pulse.enable = true;
  #  alsa = {
  #    enable = true;
  #    support32Bit = true;
  # };
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.megacron = {
    homeMode = "755";
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      zsh
    ];
  };

  # programs.firefox.enable = true;
  # NOTE: git settings
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
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inputs.megavim.packages.${pkgs.system}.default
    nixos-generators
    openssh
    xclip
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.mtr.user = "megacron";

  nix = {
    settings = {
      accept-flake-config = true;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      trusted-users = ["megacron"];
      warn-dirty = false;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
