{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.kevin.ssh;
  authorizedOpts = {name, config, ...}: {
    options = {
      /*name = mkOption { 
        type = types.passwdEntry types.str;
        description = "Name of the user. Must be the name of a directory in /etc/nixos/ssh";
      };*/
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
      kevin.networking.ssh.enable = true;
    })
    {
      users.users = mkMerge (map (name: (
        mkMerge (
          map (user: {
            "${user}".openssh.authorizedKeys.keyFiles = [
              "/etc/nixos/ssh/${name}/authorized_keys"
            ];
          }) cfg.authorized."${name}".users
        )
      )) (attrNames cfg.authorized));
    }
  ];
}
