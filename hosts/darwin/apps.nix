{ pkgs, lib, vars, ... }: {

  home.file."Library/Preferences/com.googlecode.iterm2.plist" = {
    source = ./apps/iterm2/com.googlecode.iterm2.plist;
    target = "link";
  };

  home.packages = with pkgs; [
    # CLI utilities
    # _1password-cli  # Password manager
    btop
    fastfetch
    nmap

    # GUI Applications
    iterm2          # Terminal
    obsidian        # Note-taking
    raycast         # Spotlight replacement
    utm             # Virtualization
  ];
}
