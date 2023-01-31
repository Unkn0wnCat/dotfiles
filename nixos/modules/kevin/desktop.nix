{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.kevin.desktop;
in {
  options.kevin.desktop = {
    enable = mkEnableOption "kevins desktop";
    type = mkOption {
      type = types.enum [ "gnome" "xmonad" ];
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
    (mkIf (cfg.type == "xmonad") {
      services = {
        gnome.gnome-keyring.enable = true;
        upower.enable = true;

        dbus = {
          enable = true;
          #socketActivated = true;
          # packages = [ pkgs.gnome3.dconf ];
        };

        xserver = {
          enable = true;
          # startDbusSession = true;
          layout = "de";

          libinput = {
            enable = true;
          };

          displayManager.defaultSession = "none+xmonad";

          windowManager.xmonad = {
            enable = true;
            enableContribAndExtras = true;
            extraPackages = hp: [
              hp.dbus
              hp.monad-logger
              hp.xmonad-contrib
            ];
          };

          xkbOptions = "caps:ctrl_modifier";
        }; # /xserver
      }; # /services

      hardware.bluetooth.enable = true;
      services.blueman.enable = true;

      systemd.services.upower.enable = true;


      home-manager.users.kevin = {
        home.packages = with pkgs; [
          nitrogen
          polybar
        ];

        programs.rofi = {
          enable = true;
          terminal = "${pkgs.xterm}/bin/xterm";
          # theme = ./theme.rafi;
        };
        
        services.dunst = {
          enable = true;
          iconTheme = {
            name = "Adwaita";
            package = pkgs.gnome3.adwaita-icon-theme;
            size = "16x16";
          };
          settings = {
            global = {
              monitor = 0;
              geometry = "600x50-50+65";
              shrink = "yes";
              transparency = 10;
              padding = 16;
              horizontal_padding = 16;
              font = "JetBrainsMono Nerd Font 10";
              line_height = 4;
              format = ''<b>%s</b>\n%b'';
            };
          };

        };

        services.picom = {
          enable = true;
          activeOpacity = 1.0;
          inactiveOpacity = 0.8;
          backend = "glx";
          fade = true;
          fadeDelta = 5;
          #opacityRule = [ "100:name *= 'i3lock'" ];
          shadow = false;
          settings = {
            corner-radius = 10;
            blur-background = true;
            blur-background-fixed = true;
            blur = {
              method = "gaussian";
              size = 100;
            };
          };
        };

        services.screen-locker = {
          enable = true;
          inactiveInterval = 30;
          lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
          xautolockExtraOptions = [
            "Xautolock.killer: systemctl suspend"
          ];
        };


        services.udiskie = {
          enable = true;
          tray = "always";
        };


      };

    })
  ]);
}
