# nix-base

My public nix base configuration (Mac+Linux) i use in my personal and work configurations.

## Usage

Import with:

```nix
  inputs = {
    # custom inputs
    base.url = "github:ojsef39/nix-base";
  };
```

Use like:

```nix
  outputs = { self, base }: {
    darwinConfigurations = {
      "mac" = base.inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";  # or x86_64-darwin
        modules = base.outputs.sharedModules ++ base.outputs.macModules ++ [
          # Mac-specific shell customizations
          {
            programs.zsh = {
              enable = true;
            };
          }
        ];
```

## Folder Structure

See example: <https://github.com/ojsef39/nix-personal>

