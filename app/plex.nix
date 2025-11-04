{ lib, pkgs, username, ... }:

let
  extLabel = "SamsungT7";             # label of the external drive
  extDrivePath = "/mnt/d";            # path where Windows has mounted the external drive
  mountPath = "/mnt/extssd";    # path inside NixOS VM
in

{
  programs = with pkgs.unstable; {
    plex = {
      enable = true;
      openFirewall = true;
      group = "users";
      user = "${username}";
      settings = {
        mediaLibrary = "{$mountPath}"/"${extLabel}";
      };
    };
  }


  # SSD support
  fileSystems."${mountPath}" = {
    device = "/dev/disk/by-label/${extDrivePath}";
    fsType = "exfat";
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5"
      "noauto"
      "x-systemd.after=network-online.target"
    ];
  };



  # Make sure we can mount /mnt/external-ssd in wsl




  systemd.services.plex.serviceConfig.ProtectHome = lib.mkForce false;
}
