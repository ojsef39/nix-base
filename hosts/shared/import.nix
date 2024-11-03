{ vars, pkgs, ... }:
let
  # Check if the ./programs directory exists and is not empty
  programDirs = if builtins.pathExists ./programs && builtins.length (builtins.readDir ./programs) > 0
    then builtins.attrNames (builtins.readDir ./programs)
    else [];

  # Map each directory to its default.nix path
  programModules = map (dir: ./programs/${dir}/default.nix) programDirs;

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
