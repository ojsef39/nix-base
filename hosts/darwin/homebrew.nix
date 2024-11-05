{ pkgs, lib, vars, ... }:
{
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
    casks = [
      "1password"
      "iTerm2"
    ];
  };
}
