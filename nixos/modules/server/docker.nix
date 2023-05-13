{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true; 

    daemon.settings = {
      ipv6 = true;
      fixed-cidr-v6 = "fd00::/80";
    };
  };
}
