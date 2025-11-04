_:
# INFO: https://tealdeer-rs.github.io/tealdeer/config_directories.html
#       Rust: ↑ tldr
{
  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        compact = true;
        use_pager = true;
      };
      updates = {
        auto_update = true;
      };
    };
  };
}
