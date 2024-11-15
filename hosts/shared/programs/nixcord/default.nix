{ config, pkgs, vars, ... }:

let
  themeFile = "midnight-catppuccin-macchiato.theme.css";
  themeUrl = "https://raw.githubusercontent.com/refact0r/midnight-discord/master/flavors/midnight-catppuccin-macchiato.theme.css";

  # Define theme path based on operating system
  themePath =
    if pkgs.stdenv.isDarwin
    then "/Users/${vars.user}/Library/Application Support/Vencord/themes/${themeFile}"
    else "${config.xdg.configHome}/vesktop/themes/${themeFile}";

  discordConfigDirName = if pkgs.stdenv.isDarwin
    then "Discord"
    else "discord";
  discordUpdateScript = pkgs.writeText "discord-update-settings.py" ''
    #!${pkgs.python3}/bin/python3

    import json
    import os
    import sys
    from pathlib import Path

    config_home = {
        "darwin": os.path.join(os.path.expanduser("~"), "Library", "Application Support"),
        "linux": os.environ.get("XDG_CONFIG_HOME") or os.path.join(os.path.expanduser("~"), ".config")
    }.get(sys.platform, None)

    if config_home is None:
        print("[discordUpdateScript] Unsupported operating system.")
        sys.exit(1)

    settings_path = Path(f"{config_home}/${discordConfigDirName}/settings.json")
    settings_path_temp = Path(f"{config_home}/${discordConfigDirName}/settings.json.tmp")

    if os.path.exists(settings_path):
        with settings_path.open(encoding="utf-8") as settings_file:
            try:
                settings = json.load(settings_file)
            except json.JSONDecodeError:
                print("[discordUpdateScript] settings.json is malformed, letting Discord fix itself")
                sys.exit(0)
    else:
        settings = {}

    if settings.get("SKIP_HOST_UPDATE"):
        print("[discordUpdateScript] Updates already disabled")
    else:
        skip_host_update = {"SKIP_HOST_UPDATE": True}
        settings.update(skip_host_update)

        os.makedirs(os.path.dirname(settings_path), exist_ok=True)

        with settings_path_temp.open("w", encoding="utf-8") as settings_file_temp:
            json.dump(settings, settings_file_temp, indent=2)

        settings_path_temp.rename(settings_path)
        print("[discordUpdateScript] Disabled updates")
  '';
in
{
  stylix.targets.vesktop.enable = false; # Deactivate stylix because it doesnt work on macos
  #FIX: Vencord not working
  programs.nixcord = {
    enable = true;
    discord = {
      enable = true;
      vencord = {
        enable = true;
        package = pkgs.vencord;
      };
    };
    vesktop.enable = false;
    config = {
      useQuickCss = false;
      disableMinSize = true;
      frameless = true;
      enabledThemes = [ themeFile ];
      plugins = {
        alwaysAnimate.enable = true;
        betterFolders = {
          enable = true;
          sidebar = false;
          sidebarAnim = true;
          closeAllFolders = true;
          closeAllHomeButton = true;
          forceOpen = true;
        };
        anonymiseFileNames = {
          enable = true;
          anonymiseByDefault = true;

        };
        appleMusicRichPresence.enable = true;
        betterGifPicker.enable = true;
        betterRoleContext.enable = true;
        betterSettings.enable = true;
        betterUploadButton.enable = true;
        biggerStreamPreview.enable = true;
        callTimer.enable = true;
        clearURLs.enable = true;
        customIdle = {
          enable = true;
          idleTimeout = 5.0;
          remainInIdle = true;
        };
        crashHandler.enable = true;
        experiments.enable = true;
        favoriteEmojiFirst.enable = true;
        favoriteGifSearch.enable = true;
        fixImagesQuality.enable = true;
        fullSearchContext.enable = true;
        gameActivityToggle.enable = true;
        imageZoom.enable = true;
        memberCount.enable = true;
        mentionAvatars.enable = true;
        messageClickActions.enable = true;
        messageLatency.enable = true;
        messageLinkEmbeds.enable = true;
        noDevtoolsWarning.enable = true;
        noF1.enable = true;
        noOnboardingDelay.enable = true;
        permissionsViewer.enable = true;
        pinDMs.enable = true;
        plainFolderIcon.enable = true;
        previewMessage.enable = true;
        quickMention.enable = true;
        readAllNotificationsButton.enable = true;
        reverseImageSearch.enable = true;
        sendTimestamps.enable = true;
        summaries.enable = true;
        shikiCodeblocks = {
          enable = true;
          theme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/refs/heads/main/packages/tm-themes/themes/catppuccin-macchiato.json";
        };
        translate.enable = true;
        typingIndicator.enable = true;
        typingTweaks.enable = true;
        validReply.enable = true;
        viewRaw.enable = true;
        voiceChatDoubleClick.enable = true;
        webScreenShareFixes.enable = true;
        whoReacted.enable = true;
      };
    };
  };

  # Download theme file
  home = {
    file = {
      ${themePath} = {
        source = builtins.fetchurl {
          url = themeUrl;
          sha256 = "17k26qv8f87ryqz9c04ra96122b4kqijv4mnbakgrng4ji3himgn";
        };
        force = true;
      };
      # Settings configuration
      "${config.programs.nixcord.vesktop.configDir}/settings.json" = {
        text = builtins.toJSON {
          discordBranch = "stable";
          minimizeToTray = true;
          arRPC = true;
          customTitleBar = if pkgs.stdenv.isDarwin then true else false;
        };
        force = true;
      };
      # Quick CSS configuration
      "${config.programs.nixcord.vesktop.configDir}/settings/quickCss.css" = {
        text = ''
          .titleBar_a934d8 {
            display: none !important;
          }
        '';
        force = true;
      };
    };
    activation.setupDiscordSettings =
      config.lib.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.python3}/bin/python3 ${discordUpdateScript}
      '';
  };
}
