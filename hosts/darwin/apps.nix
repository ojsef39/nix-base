{ pkgs, lib, vars, ... }: 
{
  environment.systemPackages = with pkgs; [
    # CLI utilities
    # _1password-cli  # Password manager
    act
    aichat
    btop
    cargo
    ghq
    gitlab-ci-local
    go
    gomplate
    hwatch
    kubectl
    neovide
    nmap
    progress
    python3Full
    retry
    rsync
    speedtest-cli
    wget
    whois
    yamllint

    # GUI Applications
    #FIX: Override not working
    (discord.override {
      withVencord = true;
    })  # Discord with Vencord
    obsidian        # Note-taking
    raycast         # Spotlight replacement
    stats
    utm             # Virtualization
  ];
}
