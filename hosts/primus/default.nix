{
  inputs,
  pkgs,
  ...
}:
{
  description = "NixOS Headless Raspberry Pi5 using NVME";
  imports = [
    ../common.nix
    ./disko.nix
    ../users/megacron/default.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-5
  ];

  # Boot loader
  boot = {
    initrd.availableKernelModules = [ "bcm2712-rpi5" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
      raspberryPi = {
        enable = true;
        version = 5;
      };
    };
  };

  fileSystems = {
    # Enable the root file system
    device = "/dev/nvme0n1p2";
  };

  #-----------------------HARDWARE---------------------#
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    raspberry-pi."5".enable = true;
    enableRedistributableFirmware = true;
  };

  #---------------------NETWORKING-----------------------#
  networking = {
    wireless.enable = true;
    networkmanager.enable = true;
    hostName = "primus";
  };

  #-----------------------SERVICES-----------------------#
  services = {
    # List services that should be enabled:
    fstrim.enable = true; # ssd optimizer
    libinput.enable = true; # input handler
    mullvad-vpn.package = pkgs.mullvad-vpn;
    printing.enable = false;
    tailscale.enable = true;
    tumbler.enable = true; # image/video previewer

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PermitRootLogin = "no"; # prevent root from SSH login
        PasswordAuthentication = true; # users can SSH using username and password
        KbdInteractiveAuthentication = true; # allow keyboard based auth
      };
    };


  };

  environment = {
    # etc = {
    #   # Minimal packages
    #
    #   "nixos/sops-configuration.nix" = {
    #     source = ./sops-configuration.nix;
    #     mode = "0644";
    #   };
    #   # Include sops configuration files
    #   "nixos/.sops.yaml" = lib.mkIf (builtins.pathExists ./.sops.yaml) {
    #     source = ./.sops.yaml;
    #     mode = "0644";
    #   };
    #   "nixos/secrets.yaml" = lib.mkIf (builtins.pathExists ./secrets.yaml) {
    #     source = ./secrets.yaml;
    #     mode = "0600";
    #   };
    # };

    system.stateVersion = "24.11";
    systemPackages = with pkgs; [
      dd
      git
      lsblk
    ];
  };
}
