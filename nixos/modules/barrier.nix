{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.barrier
  ];

  networking.firewall.allowedTCPPorts = [ 24800 ];
}
