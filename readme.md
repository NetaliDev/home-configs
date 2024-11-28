# Jennys home manager configurations

Some general parts of my home manager configurations. Feel free to use them as you want.

This repo currently includes:
  - `homeConfigs.vim`: My neovim configuration, which makes it look like VSCode
  - `homeConfigs.zsh`: My very basic zsh config

## Usage example
```
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    netali-home-configs.url = "github:netalidev/home-configs";
    netali-home-configs.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, netali-home-configs, ... }: {
    nixosConfigurations = {
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jdoe = {
              imports = [
                ./home.nix
                netali-home-configs.homeConfigs.vim
              ];
            };
          }
        ];
      };
    };
  };
}
```
