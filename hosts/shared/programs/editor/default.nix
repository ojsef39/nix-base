{ pkgs, lib, ... }:
let
  # Filter out lazy-lock.json from the source directory
  nvimConfigFiltered = lib.cleanSourceWith {
    src = ./nvim;
    filter = path: type: let
      baseName = baseNameOf path;
    in baseName != "lazy-lock.json";
  };
in
{
  programs.neovim = {
    enable = lib.mkDefault true;
    defaultEditor = lib.mkDefault true;
    viAlias = lib.mkDefault true;
    vimAlias = lib.mkDefault true;

    # Packages used in nvim
    extraPackages = with pkgs; [
      fd
      tree-sitter
    ];
  };

  # Packages used in nvim but also outside of it
  home.packages = with pkgs; [
    ripgrep
    git
    fzf
    eza
    lazygit
  ];

  # Copy your Neovim configuration
  xdg.configFile = {
    # Copy the filtered nvim configuration directory
    "nvim" = {
      source = nvimConfigFiltered;
      recursive = true;
    };
  };

  home.file = {
    # Ensure the .local/share/nvim directory exists with correct permissions
    ".local/share/nvim/.keep" = {
      text = "";
      onChange = ''
        mkdir -p $HOME/.local/share/nvim
        chmod 755 $HOME/.local/share/nvim
      '';
    };
  };
}
