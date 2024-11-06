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

  home.activation = {
    copyITerm2Prefs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      plist_path="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
      backup_path="$HOME/Library/Preferences/com.googlecode.iterm2.plist.backup"

      # Remove old backup if it exists
      if [ -f "$backup_path" ]; then
        $DRY_RUN_CMD sudo rm "$backup_path"
      fi

      # Backup current plist if it exists
      if [ -f "$plist_path" ]; then
        $DRY_RUN_CMD sudo mv "$plist_path" "$backup_path"
      fi

      # Copy and set up the new file
      $DRY_RUN_CMD sudo cp ${./apps/iterm2/com.googlecode.iterm2.plist} "$plist_path"
      $DRY_RUN_CMD sudo chmod 600 "$plist_path"
      $DRY_RUN_CMD sudo chown $USER "$plist_path"
    '';
  };
}
