{ username, ... }:
{
  #-----------------NIX-OPTIMIZATIONS------------------#
  nix = {
    nrBuildUsers = 64;
    settings = {
      cores = 2; # 0 means all available cores
      warn-dirty = false;
      auto-optimise-store = true;
      download-buffer-size = 240 * 1024 * 1024;
      min-free = 10 * 1024 * 1024;
      max-free = 200 * 1024 * 1024;
      max-jobs = 4; # "auto" means all, 0 means use remote specified in builders
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [
        "root"
        "${username}"
        "@wheel"
      ];
      experimental-features = [
        "flakes"
        "nix-command"
      ];

      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
      extra-trusted-public-keys = [
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # For when dangon devs use EOL dependencies, grrrr..
    ];
  };
}
