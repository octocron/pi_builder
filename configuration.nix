# nixos-generate -f sd-aarch64 -c configuration.nix

{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix> ];

  users.users.megacron = {
    openssh.authorized-Keys.keys = [ "" ];
  };

  networking = {
    hostName = "superion";
    useDHCP = true;
  };

  services = {
    openssh.enable = true;
  };
}
