{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      
    ];
    
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "amon";
  networking.domain = "srv.1in9.net";
  
  time.timeZone = "Europe/Berlin";
  
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  users.users.kevin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
    git
  ];

  system.stateVersion = "22.11"; # No touchy.

}