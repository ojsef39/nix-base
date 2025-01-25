{ config, pkgs, vars, ... }:

let
  themeFile = "midnight-catppuccin-macchiato.theme.css";
  themeUrl = "https://raw.githubusercontent.com/refact0r/midnight-discord/master/flavors/midnight-catppuccin-macchiato.theme.css";

  # Define theme path based on operating system
  themePath =
    if pkgs.stdenv.isDarwin
    then "/Users/${vars.user}/Library/Application Support/vesktop/themes/${themeFile}"
    else "${config.xdg.configHome}/vesktop/themes/${themeFile}";
in {
  stylix.targets.vesktop.enable = false; # Deactivate stylix because it doesnt work on macos
  programs.nixcord = {
    enable = true;
    discord = {
      enable = true;
      vencord = {
        enable = false;
        package = pkgs.vencord;
      };
    };
    vesktop = {
      enable = true;
      package = pkgs.vesktop.overrideAttrs (previousAttrs: {
        patches = previousAttrs.patches ++ [
          (pkgs.fetchpatch {
            name = "micfix-8fdb10b95fa4309d475ce4a47efa4bf2cba4264e.patch";
            url = "https://gist.githubusercontent.com/ojsef39/b8d8190008869b8a868b998494e3f95d/raw/8fdb10b95fa4309d475ce4a47efa4bf2cba4264e/micfix.patch";
            sha256 = "sha256-jJyg5b8D+zTpLKKpiwKRWhJZ+YXgYNxMd/7Tjjkf1N4=";
          })
        ];
      });
    };
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
  home.file = {
    ${themePath} = {
      source = builtins.fetchurl {
        url = themeUrl;
        sha256 = "0gwb46zq1kbz7xvmhwcr8ib5zfzjl00yz97507k9l7vli1q0mw52";
      };
      force = true;
    };
    # Settings configuration
    "${config.programs.nixcord.discord.configDir}/settings.json" = {
      text = builtins.toJSON {
        discordBranch = "stable";
        minimizeToTray = true;
        arRPC = true;
        customTitleBar =
          if pkgs.stdenv.isDarwin
          then true
          else false;
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
}
