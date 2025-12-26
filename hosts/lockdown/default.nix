{ pkgs, ... }:
{
  description = "NixOS configuration for Raspberry Pi 500+";
  imports = [
    ../../common.nix
    ./disko.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-5
  ];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  networking = {
    hostName = "lockdown";
  };

  system.stateVersion = "24.11";
}