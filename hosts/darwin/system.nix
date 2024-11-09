{ pkgs, vars, lib, ... }:

###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
#  See your own values with for example: `defaults read com.apple.dock tilesize`
#
###################################################################################
{
  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    startup.chime = lib.mkDefault true;

    defaults = {
      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = true;
      };

      NSGlobalDomain = {
        NSAutomaticCapitalizationEnabled = false;
        "com.apple.trackpad.scaling" = 0.6875;
        "com.apple.sound.beep.volume" = 1.0;
      };

      ".GlobalPreferences"."com.apple.mouse.scaling" = 0.6875;

      # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.CustomSystemPreferences
      CustomSystemPreferences = {};

      # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.CustomUserPreferences
      CustomUserPreferences = {
        "com.apple.dock" = {
          "contents-immutable" = 0;
          "size-immutable" = 0;
          "position-immutable" = 0;
        };
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";

        ShowPathbar = true;
        ShowStatusBar = true;
      };

      dock = {
        magnification = true;
        largesize = 62;
        show-recents = false;
        tilesize = 54;
        wvous-bl-corner = 11;
        wvous-br-corner = 14;
        wvous-tl-corner = 5;
        wvous-tr-corner = 5; # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.dock.wvous-tl-corner

        persistent-others = [
          "/Users/${vars.user}/Downloads"
        ];
      };

      WindowManager = {
        GloballyEnabled = true;
        EnableStandardClickToShowDesktop = true;
        HideDesktop = false;
        StageManagerHideWidgets = false;
      };

      alf.stealthenabled = 1; ##TODO: Move to personal

      menuExtraClock = {
        ShowDate = 2;
        ShowSeconds = true;
      };

      spaces.spans-displays = false;

      hitoolbox.AppleFnUsageType = "Show Emoji & Symbols";
    };
  };
  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
}
