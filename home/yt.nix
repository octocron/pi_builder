_:
# INFO: Python: unfortunately || yaydl is rust!
{
  programs.yt-dlp = {
    enable = true;
    settings = {
      embed-thumbnail = true;
    };
    extraConfig = ''
      --audio-format mp3
    '';
  };
}
