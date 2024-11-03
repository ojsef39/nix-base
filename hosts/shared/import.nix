{ pkgs, ... }:
let
  # Get all entries in ./programs
  entries = builtins.readDir ./programs;

  # Filter entries to include only directories and exclude hidden files
  programDirs = [ name
    for name in builtins.attrNames entries
    if entries.${name}.type == "directory" && ! builtins.hasPrefix "." name ];

  programModules = map (dir: import ./programs/${dir}/default.nix) programDirs;
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
