{
  description = "ojsef39 base nix configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:lnl7/nix-darwin/master";
  };
  outputs = inputs @ { self, nixpkgs, home-manager, darwin, vars, ... }:
  {
    sharedModules = [
      ./nix/core.nix
      home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs vars; };
            users.${vars.user} = import ./hosts/shared/import.nix;
          };
        }
    ];
    macModules = [
      ./hosts/darwin/import.nix
    ];
  };
}
