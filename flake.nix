{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: let
    lib = nixpkgs.lib;
    configs = builtins.readDir ./configs;
    configFiles = lib.filterAttrs (n: v: (lib.hasSuffix ".nix" n) && v == "regular") configs;
    configFileList = lib.mapAttrsToList (n: _: lib.removeSuffix ".nix" n) configFiles;
    homeConfigs = lib.listToAttrs (lib.map (x: {
      name = x;
      value = import (./configs + "/${x}.nix");
    }) configFileList);
  in {
    inherit homeConfigs;
  };
}
