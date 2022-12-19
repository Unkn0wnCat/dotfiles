{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.kevin.yubikey;
in {
  options.kevin.yubikey = {
    enable = mkEnableOption "yubikey setup";
  };

  config = mkIf cfg.enable (mkMerge [
    ({
      security.pam.yubico = {
        enable = true;
        debug = false;
        mode = "challenge-response";
      };

      services.udev.packages = [ pkgs.yubikey-personalization ];
    })
  ]);
}
