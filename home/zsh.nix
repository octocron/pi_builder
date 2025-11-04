{
  config,
  pkgs,
  ...
}: {
  programs = {
    # Configure zsh
    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;
      history = {
        save = 10000;
        size = 10000;
        ignoreDups = true;
        ignoreSpace = true;
        expireDuplicatesFirst = true;
      };

      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];

      shellAliases = {
        ".." = "cd ..";
        "..." = "./..";
        "...." = "././..";
        sv = "sudo vim";
        #-------------nix---------------------------------------------------->>>
        nhb = "nh boot --flake ~/projects/megaos/#desktop";
        nhg = "nh os info";
        nhr = "nh os repl";
        nhs = "nh os switch --flake ~/projects/megaos/#desktop";
        nhsu = "nh os switch --flake ~/projects/megaos/#desktop --ask";
        nht = "nh os test --flake ~/projects/megaos/#desktop";
        nrb = "sudo nixos-rebuild boot --flake ~/projects/megaos/#desktop";
        nrg = "sudo nixos-rebuild list-generations --flake ~/projects/megaos/#desktop | bat";
        nrp = "nom sudo nixos-rebuild switch --flake ~/projects/megaos/#desktop -p";
        nrs = "sudo nixos-rebuild switch --flake ~/projects/megaos/#desktop";
        nrt = "sudo nixos-rebuild test --flake ~/projects/megaos/#desktop";
        ncg = "nix-collect-garbage --delete-old";
        #-------------aliases------------------------------------------------>>>
        a = "ansible";
        ap = "ansible-playbook";
        d3 = "cd ~/projects/hugo/d3c3p7/";
        ftldr = "tldr --list | fzf --preview 'tldr {1} --color=always' --preview-window=right,70% | xargs tldr";
        grep = "grep --color";
        kf = "kitty +list-fonts";
        kg = "killall gpg-agent || true; gpg-agent --daemon";
        la = "eza --group-directories-first -la";
        ls = "eza --icons --group-directories-first";
        lt = "eza -lhTL";
        lsd = "eza -D";
        lg = "eza -lh --git";
        mostcli = "history | awk '{print $2}' | sort | uniq -c | sort -nr | head -10";
        reload = "source ${config.home.homeDirectory}/.zshrc";
        #reload ="exec $SHELL -l";
        show_path = "echo $PATH | tr ':' '\n'";
        week = "date +%V";
        wttr = "curl wttr.in";
        #-------------git---------------------------------------------------->>>
        ga = "git add .";
        gb = "git branch -a";
        gbd = "git branch -d";
        gbod = "git push origin --delete";
        gc = "git commit -S -m ";
        gco = "git checkout";
        gcob = "git checkout -b";
        gcot = "git checkout trunk";
        gd = "git diff";
        gdh = "git diff HEAD";
        gl = "git log";
        gla = "git log --all --graph --oneline";
        glo = "git log -1 --pretty=%H";
        gp = "git push";
        gpu = "git pull";
        gpt = "git push -u origin trunk";
        gph = "git push -u origin HEAD";
        gs = "git status";
        gsl = "git stash list";
        gsf = "git stash push --";
        gsp = "git stash pop";
        #-------------copy--------------------------------------------------->>>
        pbcopy = "/mnt/c/Windows/System32/clip.exe";
        pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
        explorer = "/mnt/c/Windows/explorer.exe";
      };

      envExtra = ''
        #-------------starship------------------------------------------->>>
        LFILE="/etc/*-release"
        MFILE="/System/Library/CoreServices/SystemVersion.plist"
        if [[ -f $LFILE ]]; then
          _distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
        elif [[ -f $MFILE ]]; then
          _distro="macos"

        #-------------determine-mac-model-------------------------------->>>
          _device=$(system_profiler SPHardwareDataType | awk '/Model Name/ {print $3,$4,$5,$6,$7}')

          case $_device in
            *MacBook*)     DEVICE="󰌢";;
            *)             DEVICE="";;
          esac
        fi

        # set an icon based on the distro
        # make sure your font is compatible with https://github.com/lukas-w/font-logos
        case $_distro in
            *kali*)                  ICON="󰠥";;
            *arch*)                  ICON="";;
            *debian*)                ICON="";;
            *raspbian*)              ICON="";;
            *ubuntu*)                ICON="";;
            *elementary*)            ICON="";;
            *fedora*)                ICON="";;
            *coreos*)                ICON="";;
            *gentoo*)                ICON="";;
            *mageia*)                ICON="";;
            *centos*)                ICON="";;
            *opensuse*|*tumbleweed*) ICON="";;
            *sabayon*)               ICON="";;
            *slackware*)             ICON="";;
            *linuxmint*)             ICON="";;
            *alpine*)                ICON="";;
            *aosc*)                  ICON="";;
            *nixos*)                 ICON="";;
            *devuan*)                ICON="";;
            *manjaro*)               ICON="";;
            *rhel*)                  ICON="";;
            *macos*)                 ICON="󰀵";;
            *)                       ICON="";;
        esac

        export STARSHIP_DISTRO="$ICON"
        export STARSHIP_DEVICE="$DEVICE"
        export PATH=$PATH:$HOME/.local/bin
      '';

      initContent = ''
        if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fi
        if [ -e "${config.home.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
          . "${config.home.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh"
        fi
        if [ -e /run/current-system/sw/etc/profile.d/nix-daemon.sh ]; then
        . /run/current-system/sw/etc/profile.d/nix-daemon.sh
        fi
        # fixes duplication of commands when using tab-completion
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
        export LANG=C.UTF-8
        export SOPS_AGE_KEY_FILE=${config.home.homeDirectory}/.config/sops/age/keys.txt
      '';
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';

      sessionVariables = {};
    };

    #-------------zsh plugins---------------------------------------------------->>>
    # broot config
    broot = {
      enable = true;
      enableZshIntegration = true;
    };

    # direnv config
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    # eza config
    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
    };

    # fzf config
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # nix-index config
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    # starship >>> config/starship.toml
    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    # zoxide config
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd cd"];
    };
  };
}
