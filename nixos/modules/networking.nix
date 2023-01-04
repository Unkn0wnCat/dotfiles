{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.kevin.networking;
in {
  options.kevin.networking = {
    enable = mkEnableOption "kevins networking";
    avahi.enable = mkEnableOption "avahi";
    ssh.enable = mkEnableOption "ssh";
    firewall.wireguard = mkEnableOption "wireguard exceptions";
    firewall.syncthing = mkEnableOption "syncthing exceptions";
    firewall.kdeConnect = mkEnableOption "KDE Connect exceptions";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.avahi.enable {
      services.avahi = {
        enable = true;
        nssmdns = true;
        publish.enable = true;
        publish.domain = true;
        publish.addresses = true;
        publish.workstation = true;
        publish.userServices = true;
      };
 
      networking.firewall.allowedUDPPorts = [ 5353 ];
    })
    (mkIf cfg.ssh.enable {
      services.openssh = {
        enable = true;
        # require public key authentication for better security
        passwordAuthentication = false;
        kbdInteractiveAuthentication = false;
        #permitRootLogin = "yes";
      };
      
      networking.firewall.allowedTCPPorts = [ 22 ];
    })
    (mkIf cfg.firewall.wireguard {
      networking.firewall = {
        # if packets are still dropped, they will show up in dmesg
        logReversePathDrops = true;

        allowedUDPPorts = [ 51820 ];


        # wireguard trips rpfilter up
        extraCommands = ''
          ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
          ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
        '';
        extraStopCommands = ''
          ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
          ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
        '';
      };
    })
    (mkIf cfg.firewall.syncthing {
      networking.firewall.allowedTCPPorts = [ 22000 ];
      networking.firewall.allowedUDPPorts = [ 22000 21027 ];
    })
    (mkIf cfg.firewall.kdeConnect {
      networking.firewall.allowedUDPPortRanges = [
        { from = 1714; to = 1764; }
      ];
    })
  ]);
}
