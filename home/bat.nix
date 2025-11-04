_:
# INFO: Rust: ↑ cat
# NOTE: bat --list-themes
# NOTE: bat cache --build -> installs all themes to ~/.config/bat/themes
{
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "ansi"; # installs the one theme instead of all.
      style = "numbers,changes,header";
    };
  };
}
