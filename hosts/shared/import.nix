{ pkgs, ... }:
let
  # Check if the ./programs directory exists and is not empty
  programDirs = if builtins.pathExists ./programs && builtins.length (builtins.readDir ./programs) > 0
    then builtins.attrNames (builtins.readDir ./programs)
    else [];

  programModules = map (dir: import ./programs/${dir}) programDirs;

  # Determine home directory based on system
  homeDirectory = builtins.getEnv "HOME";
in
{
  nixpkgs.config.allowUnfree = true;
  # Use imports = programModules; only if each program module returns a valid module
  imports = if builtins.isList programModules then programModules else [];

  home = {
    inherit homeDirectory;
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
