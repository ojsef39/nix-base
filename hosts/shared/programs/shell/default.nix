{ pkgs, lib, vars, ... }:

{
  # Required packages
  home.packages = with pkgs; [
    coreutils
    eza
    fastfetch
    fzf
    git
    nodejs
    python3
    tmux
    yarn
    zoxide
  ];

  ##TODO: do you really have to still install it when its enabled?
  programs.zsh = {
    enable = lib.mkDefault true;
    
    # Oh My Zsh configuration
    oh-my-zsh = {
      enable = lib.mkDefault true;
      plugins = [ "git" "node" "npm" "github" ];
    };

    # Install and configure plugins separately
    plugins = [
      {
        name = "zsh-fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "spaceship-prompt";
        src = pkgs.spaceship-prompt;
        file = "share/zsh/site-functions/prompt_spaceship_setup";
      }
    ];

    # Environment variables
    sessionVariables = {
      PATH = lib.concatStringsSep ":" [
        "/opt/homebrew/bin"
        "$HOME/Library/Python/3.12/bin"
        # "/Applications/MEGAcmd.app/Contents/MacOS" ##TODO: Move to personal
        "$HOME/CodeProjects/github.com/ojsef39/commit-oracle" ##TODO: Ensure script is actually there
        "$PATH"
      ];
      PYTHON = "/usr/bin/python3";
      GCL_TIMESTAMPS = "true";
      GCL_MAX_JOB_NAME_PADDING = "30";
    };

    ## TODO: Check if ZSH and iterm2 shell integration get right var templated in
    # Spaceship prompt configuration
    initExtra = ''
      # Initialize spaceship prompt
      source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
      autoload -U promptinit; promptinit
      bindkey -r "^j"

      eval "$(fzf --zsh)"
      eval "$(zoxide init --cmd cd zsh)"

      SPACESHIP_CHAR_SYMBOL="🚀 "
      SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
      SPACESHIP_DIR_PREFIX="🗂  "
      SPACESHIP_GIT_BRANCH_PREFIX="⚡"
      SPACESHIP_PROMPT_SUFFIXES_SHOW=false
      SPACESHIP_PROMPT_DEFAULT_PREFIX=" - "
      SPACESHIP_EXEC_TIME_SHOW=false
      SPACESHIP_GIT_PREFIX=" on "
      SPACESHIP_DOCKER_PREFIX=" on "
      SPACESHIP_PACKAGE_PREFIX=" is "
      SPACESHIP_GIT_STATUS_SHOW="false"

      # TMUX function
      n() {
        local session_name="$(basename "$PWD")"
        if [ -z "$TMUX" ]; then
          if tmux has-session -t "$session_name" 2>/dev/null; then
            tmux attach-session -t "$session_name"
          else
            tmux new-session -s "$session_name" "nvim $*"
          fi
        else
          nvim "$@"
        fi
      }
      compdef _files n

      t() {
          local session_name=$(echo "$PWD" | rev | cut -d'/' -f1-5 | rev | tr '/' '-' | tr '.' '-' | tr ':' '-')
          if [ -z "$TMUX" ]; then
              if tmux has-session -t "$session_name" 2>/dev/null; then
                  tmux attach-session -t "$session_name"
              else
                  tmux new-session -s "$session_name"
              fi
          else
            echo "Already in a tmux session"
          fi
      }

      check_repos() {
        find . -type d -name ".git" | while read gitdir; do
          repo_dir="$(dirname "$gitdir")"
          if [ -n "$(git -C "''${repo_dir}" status --porcelain)" ]; then
            echo "changes in ''${repo_dir#./}"
          fi
        done
      }

      # Load iTerm2 shell integration
      test -e "''${HOME}/.iterm2_shell_integration.zsh" && source "''${HOME}/.iterm2_shell_integration.zsh"

      # Source MEGA completion
      # source /Applications/MEGAcmd.app/Contents/MacOS/megacmd_completion.sh

      # Source additional scripts
      if [ -d $HOME/.zsh_scripts ]; then
        for file in $HOME/.zsh_scripts/*.zsh; do
          source $file
        done
      fi
      fastfetch
      tmux list-sessions
    '';

    # Aliases
    shellAliases = {
      please = "sudo";
      ls = "eza --icons --git --header";
      x = "exit";
    };
  };

  # Additional program configurations
  programs = {
    fzf = {
      enable = lib.mkDefault true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";  # Faster than find
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--color=spinner:#f4dbd6,hl:#ed8796"
        "--color=fg:#cad3f5,header:#cad3f5,info:#c6a0f6,pointer:#f4dbd6"
        "--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
      ];
    };
    zoxide = {
      enable = lib.mkDefault true;
      enableZshIntegration = true;
    };
    tmux = {
    enable = lib.mkDefault true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";
    terminal = "xterm-256color";
    plugins = with pkgs.tmuxPlugins; [
      continuum
      copycat
      open
      resurrect
      yank
      vim-tmux-navigator
    ];

    extraConfig = ''
      # Unbind default prefix and set to C-Space
      unbind C-b
      bind-key C-space send-prefix

      # Terminal overrides
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set-option -sa terminal-features  ",xterm-256color:RBG"

      # Clipboard settings
      set-option -s set-clipboard on

      # Copy mode bindings
      bind-key V copy-mode
      bind-key -T copy-mode-vi V send-keys -X cancel
      bind-key -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi v send-keys -X begin-selection

      # OS-specific copy-paste bindings
      if-shell "[[ $(uname) == 'Darwin' ]]" {
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      }{
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      }

      # Send prefix to nested session
      bind-key b send-prefix

      # Window and pane settings
      set-option -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Config reload
      bind-key r source-file ~/.tmux.conf \; display "🚀 Config reloaded."

      # Pane splitting
      unbind -
      unbind %
      unbind '"'
      unbind '|'
      bind-key j split-window -v -c "#{pane_current_path}"
      bind-key l split-window -h -c "#{pane_current_path}"

      # Pane resizing
      bind-key -r Left  resize-pane -L 1
      bind-key -r Down  resize-pane -D 1
      bind-key -r Up    resize-pane -U 1
      bind-key -r Right resize-pane -R 1

      # Secondary binding for C-l
      bind-key C-b send-keys 'C-l'

      # Activity monitoring
      set-window-option -g monitor-activity off
      set-option -g visual-activity on

      # Focus events
      set -g focus-events on

      # Status bar configuration
      set-option -g status "on"
      set-option -g status-interval 1
      set-option -g status-justify "centre"
      set-option -g status-style "bg=default"

      set-option -g status-left-length 50
      set-option -g status-left  '#[fg=#7aa2f7,bg=default]#h #[fg=#3b4261,bold,bg=default]• #[fg=#e0af68,bg=default]#(uname -s) #[fg=#3b4261,bold,bg=default]• #[fg=#f7768e,bg=default]#S #[fg=#3b4261,bold,bg=default]• #[fg=#f7768e,bg=default]#W #[fg=#3b4261,bold]• #[fg=#f7768e]#P #[fg=#3b4261,bold]'
      set-option -g status-right-length 140
      set-option -g status-right '#[fg=#f7768e,bg=default]#(uptime | cut -f 3-5 -d " " | cut -f 1 -d "," | tr -s " " | tr "u" "U")#[fg=#3b4261,bold,bg=default] • #[fg=#e0af68,bg=default]%a %Y-%m-%d#[fg=#3b4261,bold,bg=default] • #[fg=#7aa2f7,bg=default]%H:%M:%S#[fg=#3b4261,bold,bg=default]'

      # Pane colors
      set-option -g mode-style "fg=#7aa2f7,bg=#3b4261"
      set-option -g display-time 1500
      set-option -g message-command-style "fg=#7aa2f7,bg=#3b4261"
      set-option -g message-style "fg=#7aa2f7,bg=#3b4261"
      set-option -g pane-active-border-style "fg=#7aa2f7"
      set-option -g pane-border-style "fg=#3b4261"

      # Window status
      set-window-option -g window-status-separator ""
      set-window-option -g window-status-current-format ""
      set-window-option -g window-status-format ""
      '';
    };
  };
  
  home.file = {
    ".zsh_scripts/keep.zsh".text = "";  # Creates an empty .keep file to ensure directory exists
  };

  # Ensure tmux plugin manager is installed
  home.file.".tmux/plugins/tpm".source = pkgs.fetchgit {
    url= "https://github.com/tmux-plugins/tpm";
    rev = "v3.1.0";
    sha256 = "sha256-IxguT6YgQNG9sE5773FIVgkddc2pGge/rLRDzopeBag=";
    leaveDotGit = false;
  };
}
