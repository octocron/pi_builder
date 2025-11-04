_:
# INFO: run:  $n(unix)/%n(windows) - nth selected file
#             $0(unix)/%0(windows) - the hovered file
#             $@(unix)/%*(windows) - all selected files
#     block:  hide yazi, display program on main screen until exit
#    orphan:  keep process running even if yazi exits
#      desc:  describe opener and help menu
#       for:  opener only for this system, if unspecified, available for all systems
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      log.enabled = false;
      # mgr was manager but devs are derps
      mgr = {
        linemode = "size";
        ratio = [
          1
          2
          5
        ];
        sort_by = "natural";
        show_hidden = true;
        show_symlink = true;
        sort_reverse = true;
        sort_dir_first = true;
      };
      # NOTE: options: unix, linux, macos, windows
      opener = {
        edit = [
          {
            run = "nvim \"$@\"";
            block = true;
            for = "unix";
          }
          {
            run = "nvim \"%*\"";
            block = true;
            for = "windows";
          }
        ];
        play = [
          {
            run = "mpv \"$@\"";
            orphan = true;
            for = "unix";
          }
          {
            run = "iina --no-stdin $@";
            orphan = true;
            for = "macos";
          }
          {
            run = "\"C:\\Program Files\\mpv.exe\" % * ";
            orphan = true;
            for = "windows";
          }
        ];
      };
      preview = {
        tab_size = 2;
        max_width = 1000;
        max_height = 1000;
      };
    };
  };
}
