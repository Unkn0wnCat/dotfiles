{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.kevin.desktop;
in {
  options.kevin.desktop = {
    enable = mkEnableOption "kevins desktop";
    type = mkOption {
      type = types.enum [ "gnome" ];
      default = "gnome";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.type == "gnome") {
      services.xserver.enable = true;
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
      services.flatpak.enable = true;
    })
  ]);
}
