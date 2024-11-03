{
  description = "ojsef39 base nix configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:lnl7/nix-darwin/master";
  };
  outputs = { self, nixpkgs, home-manager, darwin, ... }:
  let
    vars = { user = "josefhofer"; email = "me@jhofer.de"; };
  in
  {
    sharedModules = [
      ./nix/core.nix
      home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inputs = {
              inherit nixpkgs home-manager darwin;
            };
            vars = vars;
          };
          users.${vars.user} = import ./hosts/shared/import.nix { inherit vars; };
        };
      }
      ./hosts/shared/import.nix { inherit vars; }
    ];
    macModules = [
      ./hosts/darwin/import.nix { inherit vars; }
    ];
  };
}
