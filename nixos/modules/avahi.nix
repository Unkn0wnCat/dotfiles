{
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
}