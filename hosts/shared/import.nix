{ vars, pkgs, ... }:
let
  # Get all immediate subdirectories of ./programs
  programDirs = builtins.attrNames (builtins.readDir ./programs);

  # Import each module
  programModules = map (dir: import ./programs/${dir}/default.nix) programDirs;

  # Determine home directory
  homeDirectory = builtins.getEnv "HOME";
in
{
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  imports = programModules;

  home = {
    inherit homeDirectory;
    stateVersion = "24.05";
  };
}