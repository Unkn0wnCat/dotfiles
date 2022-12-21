{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.kevin.ssh;
in {
  options.kevin.ssh = {
    server.enable = mkEnableOption "kevins ssh";
    authorized.kevin = mkEnableOption "set authorized for kevin";
  };

  config = mkMerge [
    (mkIf cfg.server.enable {
      kevin.networking.ssh.enable = true;
    })
    (mkIf cfg.authorized.kevin {
      users.users."kevin".openssh.authorizedKeys.keyFiles = [
        /etc/nixos/ssh/kevin/authorized_keys
      ];
    })
  ];
}
