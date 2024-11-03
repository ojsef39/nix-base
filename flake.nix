{
  description = "ojsef39 base nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:lnl7/nix-darwin/master";
  };

  outputs = { self, nixpkgs, home-manager, darwin }: {
    sharedModules = [
      ./nix/core.nix
      ./hosts/shared/import.nix
      home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          # extraSpecialArgs = { inherit vars inputs; };
          username = builtins.getEnv "USER";
          homeDirectory = builtins.getEnv "HOME";
        };
      }
    ];
    macModules = [
      ./hosts/darwin/import.nix
    ];
  };
}
