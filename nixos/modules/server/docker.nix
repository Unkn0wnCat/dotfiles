{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true; 

    daemon.settings = {
      ipv6 = true;
      fixed-cidr-v6 = "2001:db8:1::/64";
      ip6tables = true;
      experimental = true;
    };
  };
}
