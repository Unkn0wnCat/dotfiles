{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.kevin.ssh;
  authorizedOpts = {name, config, ...}: {
    options = {
      users = mkOption {
        type = with types; listOf types.str;
        default = [];
        example = [
          "kevin"
          "root"
        ];
        description = "Accounts this SSH key should have access to";
      };
    };
  };
in {

  options.kevin.ssh = {
    server.enable = mkEnableOption "kevins ssh";
    authorized = mkOption {
      default = {};
      type = with types; attrsOf (submodule authorizedOpts);
      example = {
        kevin = {
          users = [ "kevin" "root" ];
        };
      };
      description = "Object containing users and the accounts they are authorized for.";
    };
  };

  config = mkMerge [
    (mkIf cfg.server.enable {
      services.openssh = {
        enable = true;
        # require public key authentication for better security
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
        #permitRootLogin = "yes";
      };
      
      networking.firewall.allowedTCPPorts = [ 22 ];
    })
    {
      users.users = mkMerge (map (name: (
        mkMerge (
          map (user: {
            "${user}".openssh.authorizedKeys.keys = 
              (lib.strings.splitString "\n" 
                (lib.strings.removeSuffix "\n" 
                  (builtins.readFile (./. + "/../../ssh/${name}/authorized_keys"))));
          }) cfg.authorized."${name}".users
        )
      )) (attrNames cfg.authorized));
    }
  ];
}
