{ pkgs, ... }:
let
  # Get all entries in ./programs
  entries = builtins.readDir ./programs;

  # Combine filtering and importing in one pass
  programModules = builtins.foldl' (acc: name:
    if entries.${name}.type == "directory" && ! (builtins.hasPrefix "." name)
    then acc ++ [(import ./programs/${name}/default.nix)]
    else acc
  ) [] (builtins.attrNames entries);

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
