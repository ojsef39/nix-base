{ vars, pkgs, ... }:
let
  # Get all immediate subdirectories of ./programs
  programDirs = builtins.attrNames (builtins.readDir ./programs);

  # Map each directory to its default.nix path
  programModules = map (dir: ./programs/${dir}/default.nix) programDirs;

  # Determine home directory based on system
  homeDirectory = if pkgs.stdenv.isDarwin
    then "/Users/${vars.user}/"
    else "/home/${vars.user}";

  tracedHomeDirectory = builtins.toPath homeDirectory;

in
{
  nixpkgs.config.allowUnfree = true;

  home-manager.users.${vars.user} = {
    home.stateVersion = "24.05";
    home.homeDirectory = tracedHomeDirectory;

    programs.home-manager = {
      enable = true;
    };

    imports = programModules;
  };
}
