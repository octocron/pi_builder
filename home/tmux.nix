{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    shortcut = "a";
    historyLimit = 5000;
    terminal = "screen-256color";
    plugins = with pkgs.tmuxPlugins; [
      fingers
      jump
      sensible
      vim-tmux-navigator
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-powerline true
          set -g @dracula-military-time true
          set -g @dracula-show-left-icon session
          set -g @dracula-plugins "ssh-session git cpu-usage ram-usage hostname time"
          set -g @dracula-git-colors "cyan dark_gray"
          set -g @dracula-cpu-usage-label "CPU"
          set -g @dracula-cpu-usage-colors "orange dark_gray"
          set -g @dracula-ram-usage-label "RAM"
          set -g @dracula-ram-usage-colors "red dark_gray"
          set -g @dracula-show-ssh-session-port true
          set -g @dracula-ssh-session-colors "yellow dark_gray"
        '';
      }
    ];
    extraConfig = ''
      # enable mouse
      set -g mouse on

      unbind %
      bind | split-window -h

      unbind '"'
      bind - split-window -v

      unbind r
      bind r source-file ~/.tmux.conf

      # shift + alt to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      # resize in vim fashion
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5

      # maximize with m instead of z(zoom)
      bind -r m resize-pane -Z

      # use pwd when opening new pane
      bind '-' split-window -v -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"

      bind-key -T copy-mode-vi 'v' send -X begin-selection # start selecting text with "v"
      bind-key -T copy-mode-vi 'y' send -X copy-selection # copy text with "y"

      unbind -T copy-mode-vi MouseDragEnd1Pane # don't exit copy mode when dragging with mouse
    '';
  };
}
