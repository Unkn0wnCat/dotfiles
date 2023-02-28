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
        inputs.sops-nix.nixosModules.sops
        ./modules/users.nix
        ./modules/common.nix
      ];
    })
  ];
  homeManagerSetup = [
    ({...}: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.sharedModules = [
            inputs.sops-nix.homeManagerModules.sops
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.kevin = import ../home-manager/kevin/home.nix;
        }
      ];

    })
  ];
in
{
  flake.nixosConfigurations = {
    kevin-tp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = defaultModules ++ homeManagerSetup ++ [
        ./kevin-tp/configuration.nix
      ];
    };
    kevin-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = defaultModules ++ homeManagerSetup ++ [
        ./kevin-pc/configuration.nix
      ];
    };
  };
}