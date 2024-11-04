{ vars, pkgs, lib, ... }:
let
  # Determine home directory based on system
  homeDirectory = if pkgs.stdenv.isDarwin
    then "/Users/${vars.user}"
    else "/home/${vars.user}";

in
{
  imports =
    [
        ./apps.nix
        # ./system.nix
        # ./host-users.nix
    ];

  home = {
    homeDirectory = lib.mkForce homeDirectory;
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
