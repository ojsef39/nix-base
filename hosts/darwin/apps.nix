{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # CLI utilities
    _1password-cli  # Password manager
    btop
    fastfetch
    nmap

    # GUI Applications
    _1password-gui  # Password manager
    iterm2          # Terminal
    obsidian        # Note-taking
    raycast         # Spotlight replacement
    utm             # Virtualization
  ];

  # Homebrew for macOS-specific and unavailable packages
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

   taps = [];

    # Mac App Store apps
    masApps = {};

    # Homebrew formulae (CLI tools)
    brews = [
      "mas"
    ];

    # macOS-specific apps and those not available/stable in nixpkgs
    casks = [];
  };

  home.file."Library/Preferences/com.googlecode.iterm2.plist" = {
    source = ./apps/iterm2/com.googlecode.iterm2.plist;
    target = "link";
  };
}
