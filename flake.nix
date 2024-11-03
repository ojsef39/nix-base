{
  description = "ojsef39 base nix configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:lnl7/nix-darwin/master";
  };
  outputs = inputs @ { self, nixpkgs, home-manager, darwin, ... }: {
    sharedModules = [
      ./nix/core.nix
      home-manager.darwinModules.home-manager
      ({ config, ... }: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
          users = {
            ${config.vars.user} = import ./hosts/shared/import.nix;
          };
        };
      })
    ];
    macModules = [
      ./hosts/darwin/import.nix
    ];
  };
}