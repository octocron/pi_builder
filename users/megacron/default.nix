{ pkgs, ... }:
{
  users = {
    defaultUserShell = pkgs.zsh;
    users.megacron = {
      homeMode = "700";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
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
  };
}
