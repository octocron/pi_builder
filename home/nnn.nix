{pkgs, ...}:
# INFO: https://www.mankier.com/nnn
#       https://github.com/jarun/nnn/blob/master/plugins/README.md
{
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override {withNerdIcons = true;};

    # NOTE: dependencies of selected plugins
    extraPackages = with pkgs; [
      autojump
      bat
      curl
      eza
      ffmpegthumbnailer
      ffsend
      fzf
      #imv
      jq
      jump
      mediainfo
      #sxiv
      tree
      viu
    ];

    plugins = {
      src = "${pkgs.nnn.src}/plugins";
      mappings = {
        c = "fzcd";
        i = "imgview";
        j = "autojump";
        o = "fzopen";
        p = "preview-tui";
        u = "upload";
      };
    };
  };
}
