{ pkgs, lib, vars, ... }:
{
  # Homebrew for macOS-specific and unavailable packages
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # cleanup = "uninstall"; ##TODO: Readd this when all packages are set
      # cleanup = "zap"; ##TODO: When im done 
    };

   taps = [];

    # Mac App Store apps
    masApps = {};

    # Homebrew formulae (CLI tools)
    brews = [
      "ca-certificates"
      "coreutils"
      "keyring"
      "helm"
      "mas"
    ];

    # macOS-specific apps and those not available/stable in nixpkgs
    casks = [
      "1password"
      "1password-cli"
      "caffeine"
      "ChatGPT"
      "Lens"
      "kitty"
      "mac-mouse-fix"
      "poe"
      "scroll-reverser"
      # "orbstack"
    ];
  };
}
