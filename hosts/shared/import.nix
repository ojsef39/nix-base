sharedModules = [
  ./nix/core.nix
  home-manager.darwinModules.home-manager
  ./hosts/shared/import.nix

  {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inputs = {
          inherit nixpkgs home-manager darwin;
        };
      };
      users.${builtins.getEnv "USER"} = import ./home;
    };
  }
];