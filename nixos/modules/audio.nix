{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.kevin.audio;
in {
  options.kevin.audio = {
    enable = mkEnableOption "kevins audio";
  };

  config = mkIf cfg.enable (mkMerge [
    ({
      hardware.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
    })
  ]);
}
