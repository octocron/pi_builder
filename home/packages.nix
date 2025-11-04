{pkgs, ...}: {
  home.packages = with pkgs; [
    # cli tools
    age
    asciinema # Rust: terminal recorder
    aria2 # C++: ↑ wget
    bandwhich # Rust: real time network monitor
    bottom # Rust: ↑ htop
    btop # C++: htop
    bzip3 # C: ↑ bzip2
    cargo-cache # Rust:
    cargo-expand # Rust:
    cmatrix # C: terminal matrix
    cmus # C: terminal music player
    #cointop # Go: cryto market
    comma # Rust: like nix shell
    croc # Go: ↑ magic-wormhole
    curl # C:
    curlie # Go: frontend to curl that add use of httpie
    ctop # Go: htop for containers
    diff-so-fancy # Perl: ↑ diff
    dogdns # Rust: ↑ dig
    dust # Rust: ↑ du
    duf # Go: ↑ df
    exiftool # Perl: ↑ exif
    fd # Rust: ↑ find
    fdupes # C: deduplicator
    ffmpeg # C:
    ffmpegthumbnailer # C++: lightweight video thumbnailer
    figlet # C: ascii art banner generator | http://www.figlet.org/examples.html
    findutils # C: has find xargs
    font-awesome
    fq # Go: ↑ jq for binary
    fx # Go: ↑ JSON viewer
    gh # Go: github cli
    git-crypt # C++:
    gitmoji-cli # JS: emoji commit messages
    glab # Go: gitlab cli (like gh)
    glances # Python: ↑ resource monitor
    gnupg # C: gpg **
    go # Assembly: garbage collector | C++: frontend
    gping # Rust: ↑ ping
    grex # Rust: ↑ regex
    hex # Rust: ↑ xxd
    hugo # static site generator
    hyperfine # Rust: cmd benchmark
    imagemagick # C: edit compose convert images
    inxi # Bash: ↑ system info
    just # ↑ make
    lazydocker # Go: full docker mgmt app
    lazygit # Go: full git mgmt app
    lua # C:
    man-db # C:
    material-icons
    mosh # C++:
    most # C: ↑ less
    navi # Rust: cli cheatsheet
    nix-melt # Rust: ranger-like flake.lock viewer
    noto-fonts-color-emoji
    nurl # Rust: ↑ fetch hash from repo url
    pciutils # C: Bins (lspci, pcilmr, setpci) needed for inxi as inspection tool
    pkg-config # C:
    procs # Rust: ↑ ps
    rage # Rust: ↑ age
    ripgrep # Rust: ↑ grep
    ripgrep-all # Rust: ↑ extend rg to search pdf, docx, etc
    rsync # C: inc file xfer
    rustic # Rust: deduplicated backup
    rustup # Rust: rust toolchain
    scc # Go: code count
    scriptisto # Rust: ↑ script editor
    sd # Rust: ↑ sed
    sniffnet # Rust: ↑ wireshark
    socat # C: for screenshots
    sops
    ssh-to-age
    spacer # Rust: ↑ insert space when cli output stops
    speedread # Perl:
    termusic # Rust: ↑ cmus
    tmate # C: instant terminal sharing
    tokei # Rust: ↑ stats about code project
    tre # C: ↑ tree
    trippy # Rust: ↑ traceroute + ping + bandwhich in one
    ttyper # Rust: ↑ typing game
    unrar # C:
    unzip # C:
    up # Go: ↑ pipe with live preview
    uutils-coreutils # Rust: ↑ coreutils rewrite
    viddy # Rust: ↑ watch
    vim # C: ↑↑ modal editor
    w3m # C: text based browser
    wget # C: ↑ download
    wthrr # Rust: ↑ wttr
    yaydl # Rust: ↑ youtube-dl
    yq-go # Go: yaml processor
    zip # C: zip files
    zoxide # Rust: ↑ cd

    # nix search
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
  ];
}
