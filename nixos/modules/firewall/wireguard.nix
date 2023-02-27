{ lib, ... }: 
let 
  wireguardPort = 51820;
in
{
  networking.firewall = {
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;

    allowedUDPPorts = [ wireguardPort ];

    # wireguard trips rpfilter up
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport ${toString wireguardPort} -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport ${toString wireguardPort} -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport ${toString wireguardPort} -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport ${toString wireguardPort} -j RETURN || true
    '';
  };
}