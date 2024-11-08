{ pkgs, inputs, lib, ... }:

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
      NSGlobalDomain = {
        NSAutomaticCapitalizationEnabled = false;
        "com.apple.trackpad.scaling" = 0.6875;
        "com.apple.sound.beep.volume" = 1.0;
      };

      ".GlobalPreferences"."com.apple.mouse.scaling" = 4.0;

      # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.CustomSystemPreferences
      CustomSystemPreferences = {
        "com.apple.Dock" = {
            "com.apple.Dock.contents-immutable" = true;
            "com.apple.Dock.size-immutable" = true;
            "com.apple.Dock.position-immutable" = true;
          };
      };

      # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.CustomUserPreferences
      CustomUserPreferences = {};

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
        show-recents = true;
        static-only = true;
        tilesize = 54;
        wvous-bl-corner = 11;
        wvous-br-corner = 14;
        wvous-tl-corner = 5;
        wvous-tr-corner = 5; # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.dock.wvous-tl-corner

        persistent-others = [
          "~/Downloads/"
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
