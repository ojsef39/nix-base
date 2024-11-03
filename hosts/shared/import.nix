{ pkgs, ... }:
let
  # Get all entries in ./programs
  entries = builtins.readDir ./programs;

  # Filter entries to include only directories and exclude hidden files
  programDirs = builtins.filter (name:
    entries.${name}.type == "directory" && ! builtins.hasPrefix "." name
  ) (builtins.attrNames entries);

  # Map over the program directories to import each module
  programModules = map (dir: import ./programs/${dir}/default.nix) programDirs;

  # Determine home directory based on system
  homeDirectory = builtins.getEnv "HOME";
in
{
  nixpkgs.config.allowUnfree = true;
  imports = programModules;

  home = {
    inherit homeDirectory;
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
