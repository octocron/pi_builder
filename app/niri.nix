{
  config,
  pkgs,
  ...
}: {
  programs.niri = {
    enable = true;

    settings = {
      input = {
        keyboard = {
          xkb = {
            layout = "us"; # Adjust as needed
          };
        };

        touchpad = {
          tap = true;
          natural-scroll = true;
        };
      };

      layout = {
        gaps = 8;
        center-focused-column = "never";
        preset-column-widths = [
          {proportion = 1.0 / 3.0;}
          {proportion = 1.0 / 2.0;}
          {proportion = 2.0 / 3.0;}
        ];
        default-column-width = {
          proportion = 1.0 / 2.0;
        };
        focus-ring = {
          width = 4;
          active-color = [
            46
            52
            64
            255
          ];
          inactive-color = [
            76
            86
            106
            255
          ];
        };
      };

      binds = lib.mkOptionDefault {
        "Mod+T" = {
          spawn = ["foot"];
        }; # Replace 'foot' with your preferred terminal, e.g., 'alacritty' or 'kitty'
        "Mod+Q" = {
          "close-window" = {};
        };
        "Mod+Shift+E" = {
          quit = {};
        };
        "Mod+D" = {
          spawn = ["bemenu-run"];
        }; # App launcher, replace with 'wofi' or 'rofi' if preferred
        "Print" = {
          screenshot = {};
        };
        "Mod+Left" = {
          "focus-column-left" = {};
        };
        "Mod+Right" = {
          "focus-column-right" = {};
        };
        "Mod+Up" = {
          "focus-window-up" = {};
        };
        "Mod+Down" = {
          "focus-window-down" = {};
        };
        "Mod+Ctrl+Left" = {
          "move-column-left" = {};
        };
        "Mod+Ctrl+Right" = {
          "move-column-right" = {};
        };
        "Mod+1" = {
          "focus-workspace" = 1;
        };
        "Mod+2" = {
          "focus-workspace" = 2;
        };
        "Mod+3" = {
          "focus-workspace" = 3;
        };
        # Add more workspaces as needed
      };

      # Optional: Spawn programs at startup
      "spawn-at-startup" = [
        {spawn = "waybar";}
      ];

      # For Raspberry Pi 4, you might need to configure outputs if using HDMI
      # outputs."HDMI-A-1" = {
      #   mode = {
      #     width = 1920;
      #     height = 1080;
      #     refresh = 60.0;
      #   };
      # };
    };
  };

  # Ensure necessary packages are installed
  environment.systemPackages = with pkgs; [
    niri
    foot # Or your terminal
    bemenu # Or your launcher
    waybar
    # Add more as needed, like swaylock for locking
  ];

  # For Wayland support on Pi 4
  hardware.opengl.enable = true;
}
