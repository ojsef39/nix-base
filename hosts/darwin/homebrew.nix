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
      "act"
      "aichat"
      "ca-certificates"
      "coreutils"
      "ghq"
      "gitlab-ci-local"
      "hwatch"
      "keyring"
      "mas"
      "ncdu"
      "neovide"
      "nmap"
      "speedtest-cli"
      "whois"
      "yamllint"
    ];

    # macOS-specific apps and those not available/stable in nixpkgs
    casks = [
      "1password"
      "1password-cli"
      "ChatGPT"
      "ChatGPT"
      "Lens"
      "mac-mouse-fix"
      "pdk"
      "poe"
      "scroll-reverser"
      "kitty"
      # "orbstack"
    ];
  };
}
