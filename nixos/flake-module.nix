{self, inputs, ...}: 
let 
  inherit (inputs.nixpkgs) lib;
  inherit (inputs) nixpkgs;

  defaultModules = [
    {
      _module.args.self = self;
      _module.args.inputs = self.inputs;
    }
    ({ ... }: {
      #srvos.flake = self;
      #documentation.info.enable = false;
      #services.envfs.enable = true;

      imports = [
        #inputs.sops-nix.nixosModules.sops
        ./modules/users.nix
        ./modules/common.nix
      ];
    })
  ];
in
{
  flake.nixosConfigurations = {
    kevin-tp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = defaultModules ++ [
        inputs.home-manager.nixosModules.home-manager
        ./kevin-tp/configuration.nix
      ];
    };
  };
}