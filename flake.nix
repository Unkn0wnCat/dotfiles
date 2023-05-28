{
  description = "Kevin's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix = {
      url = github:Mic92/sops-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-parts, ... }:
    (flake-parts.lib.evalFlakeModule
      { inherit inputs; }
      {
        imports = [
          ./nixos/flake-module.nix
        ];
        systems = [ "x86_64-linux" ];
        #perSystem = { config, self', inputs', pkgs, system, ... }: {
          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.

          # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
          # packages.default = pkgs.hello;
        #};
    }).config.flake;
}
