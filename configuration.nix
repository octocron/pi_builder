# nixos-generate -f sd-aarch64 -c configuration.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [<nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>];

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

  users.users.megacron = {
    homeMode = "755";
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorized-Keys.keys = [""];
  };
}
