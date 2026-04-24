{
  config,
  gitUsername,
  pkgs,
  username,
  ...
}:
{
  #-----------------------USERS-----------------------#
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      "${username}" = {
        homeMode = "755";
        linger = true; # NOTE: for restarting services after reboot
        isNormalUser = true;
        description = "${gitUsername}";
        extraGroups = [
          "docker"
          "libvirtd"
          "networkmanager"
          "wheel"
        ];
        hashedPasswordFile = config.sops.secrets.passwordHash.path;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7Nb8wXQWd9H69U6TzPoE1MJDzUbGZSwwJCaXBvzgdb megacron"
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBG++DllhoaxmTnSQ155B0dgEbRO+XHsXP8a3znDm8YesXYcct+cDvV1ysf7HEP/9jaQmrbOSXKtdC1bA3fYU4mk= drift"
        ];
      };
    };
  };
}
