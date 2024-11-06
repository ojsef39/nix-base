{ pkgs, lib, vars, ... }: 
{
  home.packages = with pkgs; [
    # CLI utilities
    # _1password-cli  # Password manager
    btop
    fastfetch
    nmap

    # GUI Applications
    obsidian        # Note-taking
    raycast         # Spotlight replacement
    utm             # Virtualization
  ];
}
