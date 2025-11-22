{
  config,
  pkgs,
  ...
}:
{
  imports = [
    # Hardware configuration for Raspberry Pi 5
  ];

  # Enable Raspberry Pi 5 hardware
  hardware = {
    raspberry-pi."5".enable = true;
    enableRedistributableFirmware = true;
  };
  # Boot loader
  boot.loader.raspberryPi = {
    enable = true;
    version = 5;
  };

  # Headless configuration
  services.openssh.enable = true;

  # Wireless networking
  networking.wireless.enable = true;

  # Hostname
  networking.hostName = "whirl";

  # User
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
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

    systemPackages = with pkgs; [
      vim
      git
    ];
  };

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
