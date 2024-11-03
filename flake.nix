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
      {
        home.username = builtins.getEnv "USER";
        home.homeDirectory = builtins.getEnv "HOME";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
    macModules = [
      ./hosts/darwin/import.nix
    ];
  };
}
