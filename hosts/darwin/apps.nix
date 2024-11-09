{ pkgs, lib, vars, ... }: 
{
  environment.systemPackages = with pkgs; [
    # CLI utilities
    # _1password-cli  # Password manager
    btop
    fastfetch
    kubectl
    nmap

    # GUI Applications
    obsidian        # Note-taking
    raycast         # Spotlight replacement
    utm             # Virtualization
  ];
}
