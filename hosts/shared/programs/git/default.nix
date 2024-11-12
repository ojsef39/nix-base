{ pkgs, lib, vars, ...}: {
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ~/.gitconfig
  '';

  home.packages = with pkgs; [
    difftastic
  ];

  programs.git = {
    enable = lib.mkDefault true;
    lfs.enable = lib.mkDefault true;

    userName = "${vars.full_name}";
    userEmail = "${vars.email}";

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = lib.mkDefault true;
      pull.rebase = lib.mkDefault true;
      
      # Difftastic configuration
      diff = {
        tool = "kitty";
        guitool = "kittygui";
        external = "difft"; # Add difftastic as external diff tool
      };
      
      pager = {
        difftool = "less -RFX"; # Configure pager for difftastic
      };

      difftool = {
        prompt = false;
        trustExitCode = true;
        kitty = {
          cmd = "kitten diff --to $LOCAL --from $REMOTE";
        };
        kittygui = {
          cmd = "kitten diff --to $LOCAL --from $REMOTE";
        };
      };

      tag.forceSignAnnotated = lib.mkDefault false;
    };

    aliases = {
      # Your existing aliases
      mr = "!sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
      amend = "commit --amend -m";
      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };

    delta = {
      enable = lib.mkDefault true;
      options = {
        features = "side-by-side";
      };
    };
  };
}
