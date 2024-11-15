{
  description = "ojsef39 base nix configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:lnl7/nix-darwin/master";
    yuki.url = "github:frostplexx/yuki";
    stylix.url = "github:danth/stylix";
    nixcord.url = "github:kaylorben/nixcord";
  };
  outputs = inputs @ { self, nixpkgs, home-manager, darwin, yuki, ... }:
  {
    sharedModules = [
      ./nix/core.nix
      home-manager.darwinModules.home-manager
      inputs.nixcord.homeManagerModules.nixcord
      ({ vars, system, ... }: {  # system is now available here
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          extraSpecialArgs = { inherit vars inputs; };
          users.${vars.user} = import ./hosts/shared/import.nix;
        };
        environment.systemPackages = [ yuki.packages.${system.darwin.aarch}.default ];
      })
      ({ config, pkgs, ... }: {
        nixpkgs.config.allowUnfree = true;
      })
    ];

    macModules = [
      inputs.stylix.darwinModules.stylix
      ./hosts/darwin/import.nix
      ./hosts/darwin/homebrew.nix
    ];
  };
}
