{
  description = "ojsef39 base nix configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:lnl7/nix-darwin/master";
  };
  outputs = inputs @ { self, nixpkgs, home-manager, darwin, ... }:
  {
    sharedModules = [
      ./nix/core.nix
      home-manager.darwinModules.home-manager
      ({ vars, ... }: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit vars inputs; };
          users.${vars.user} = import ./hosts/shared/import.nix;
        };
      })
    ];
    macModules = [
      home-manager.darwinModules.home-manager
      ({ vars, ... }: {
        home-manager.users.${vars.user} = import ./hosts/darwin/import.nix;
      })
      ./hosts/darwin/homebrew.nix
    ];
  };
}
