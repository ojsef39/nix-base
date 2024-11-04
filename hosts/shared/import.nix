{ vars, pkgs, ... }:
let
  # Get all immediate subdirectories of ./programs
  programDirs = builtins.attrNames (builtins.readDir ./programs);

  # Map each directory to its default.nix path
  programModules = map (dir: ./programs/${dir}/default.nix) programDirs;

  # Determine home directory based on system
  homeDirectory = if pkgs.stdenv.isDarwin
    then "/Users/${vars.user}"
    else "/home/${vars.user}";

  # Trace the value of homeDirectoryPath
  tracedHomeDirectory = builtins.trace "homeDirectory: ${homeDirectory}" homeDirectory;

in
{
  nixpkgs.config.allowUnfree = true;
  imports = programModules;

  home = {
    homeDirectory = tracedHomeDirectory;
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
