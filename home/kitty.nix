{pkgs, ...}: {
  # Configure Kitty
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;

    font = {
      size = 12;
      name = "Maple Mono";
      package = pkgs.maple-mono.opentype;
    };

    settings = {
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;
      window_padding_width = 6;
      confirm_os_window_close = 0;
      background_opacity = "0.85";
      copy_on_select = "yes";

      # OS Window titlebar colors
      wayland_titlebar_color = "system";
      macos_titlebar_color = "system";
      macos_option_as_alt = true;

      # tab
      tab_fade = "1";
      tab_bar_style = "fade";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "bold";
      tab_bar_background = "#101014";
      active_tab_foreground = "#3d59a1";
      active_tab_background = "#1a1b26";
      inactive_tab_foreground = "#787c99";
      inactive_tab_background = "#16161e";

      # base
      foreground = "#2ac3de";
      background = "#1a1b26";
      selection_foreground = "#f4dbd6";
      selection_background = "#28344a";

      # cursor
      cursor = "#ee4400";
      cursor_text_color = "#1a1b26";

      # kitty window borders
      active_border_color = "#3d59a1";
      inactive_border_color = "#101014";
      bell_border_color = "#ee1b1b";

      # URL underline during hover
      url_color = "#0000ff";

      # blacks
      color0 = "#414868";
      color8 = "#414868";

      # reds
      color1 = "#0066cc";
      color9 = "#0066cc";

      # greens
      color2 = "#228800";
      color10 = "#228800";

      # yellows
      color3 = "#ffaa00";
      color11 = "#ffaa00";

      # blues
      color4 = "#aa44cc";
      color12 = "#aa44cc";

      # magentas
      color5 = "#ff9900";
      color13 = "#5277c3";

      # cyans
      color6 = "#990011";
      color14 = "#990011";

      # whites
      color7 = "#ee4400";
      color15 = "#ee4400";
    };

    keybindings = {
      #"ctrl+backspace" = "send_text all \\x17";
      #"kitty_mod+t" = "new_tab";
      #"kitty_mod+shift+t" = "new_tab_with_cwd";
      #"kitty_mod+w" = "close_tab";
      #"kitty_mod+r" = "set_tab_title";
      #"kitty_mod+shift+left" = "move_tab_backward";
      #"kitty_mod+shift+right" = "move_tab_forward";
      "kitty_mod+1" = "goto_tab 1";
      "kitty_mod+2" = "goto_tab 2";
      "kitty_mod+3" = "goto_tab 3";
      "kitty_mod+4" = "goto_tab 4";
      "kitty_mod+5" = "goto_tab 5";
      "kitty_mod+6" = "goto_tab 6";
      "kitty_mod+7" = "goto_tab 7";
      "kitty_mod+8" = "goto_tab 8";
      "kitty_mod+9" = "goto_tab 9";
      "kitty_mod+0" = "goto_tab 10";
      #"ctrl+shift+c" = "copy_to_clipboard";
      #"ctrl+shift+v" = "paste_from_clipboard";
      # "alt+left" = "send_text all \\x1b\\x62";
      # "alt+right" = "send_text all \\x1b\\x66";
    };
  };
}
