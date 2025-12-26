{ config, ... }:
let
  username = "megacron";
  gitEmail = "megacron@d3c3p7.com";
in
{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        light = false;
        line-numbers = true;
        navigate = true;
        side-by-side = true;
      };
    };
    ignores = [
      ".direnv"
      "result"
      ".DS_Store"
    ];
    lfs.enable = true;
    userEmail = "${gitEmail}";
    userName = "${username}";

    extraConfig = {
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
      user.signingkey = "~/.ssh/id_${config.networking.hostname}";
      core.editor = "nvim";
      diff.colorMoved = "default";
      init.defaultBranch = "trunk";
      merge.conflictstyle = "zdiff3";
      commit = {
        gpgsign = true;
        verbose = true;
      };
      push = {
        default = "current";
        autoSetupRemote = true;
      };
    };
  };
}
