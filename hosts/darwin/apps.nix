{ pkgs, lib, vars, ... }: 
{
  environment.systemPackages = with pkgs; [
    # CLI utilities
    # _1password-cli  # Password manager
    act
    aichat
    btop
    fastfetch
    ghq
    gitlab-ci-local
    gomplate
    hwatch
    kubectl
    ncdu
    neovide
    nmap
    progress
    speedtest-cli
    whois
    yamllint

    # GUI Applications
    caffeine        # Prevents sleep
    discord         ##TODO: Add vencord
    obsidian        # Note-taking
    raycast         # Spotlight replacement
    stats
    utm             # Virtualization
  ];
}
