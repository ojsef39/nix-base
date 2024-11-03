{ vars, pkgs, ... }:
let
  # Get all immediate subdirectories of ./programs
  programDirs = builtins.attrNames (builtins.readDir ./programs);

  # Trace the programDirs value
  tracedProgramDirs = builtins.trace "programDirs: ${builtins.toString programDirs}" programDirs;

  # Map each directory to its default.nix path
  programModules = map (dir: ./programs/${dir}/default.nix) tracedProgramDirs;

  # Trace the programModules value
  tracedProgramModules = builtins.trace "programModules: ${builtins.toString programModules}" programModules;

  # Determine home directory based on system
  homeDirectory = if pkgs.stdenv.isDarwin
    then "/Users/${vars.user}"
    else "/home/${vars.user}";

  # Trace the homeDirectory value
  tracedHomeDirectory = builtins.trace "homeDirectory: ${homeDirectory}" homeDirectory;
in
{
  nixpkgs.config.allowUnfree = true;

  home-manager.users.${vars.user} = {
    home.stateVersion = "24.05";
    home.homeDirectory = tracedHomeDirectory;

    programs.home-manager = {
      enable = true;
    };

    imports = tracedProgramModules;
  };
}
