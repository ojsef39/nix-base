{ vars, pkgs, lib, ... }:
{
  nix.nixPath = [
    "darwin=$HOME/.nix-defexpr/channels/darwin"
    "nixpkgs=${pkgs.path}"
  ];
  imports =
    [
        ./apps.nix
        ./system.nix
        # ./host-users.nix
        ./stylix.nix
    ];
}
