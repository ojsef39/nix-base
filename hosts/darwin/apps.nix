{ pkgs, lib, vars, ... }: {

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

  home.file."Library/Preferences/com.googlecode.iterm2.plist" = {
    source = ./apps/iterm2/com.googlecode.iterm2.plist;
    target = "Library/Preferences/com.googlecode.iterm2.plist";
  };
}
