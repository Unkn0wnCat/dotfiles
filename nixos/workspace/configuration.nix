{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      
      ../modules/gnome.nix
      ../modules/pipewire.nix
      ../modules/avahi.nix
      ../modules/firewall/kde-connect.nix
      ../modules/firewall/syncthing.nix
      ../modules/firewall/wireguard.nix
      #../modules/yubikey.nix
      #../modules/gaming/steam.nix
      #../modules/gaming/helpers.nix
      #../modules/barrier.nix
      #../modules/restic.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  #services.gnome.gnome-remote-desktop.enable = true;
  networking.firewall.allowedTCPPorts = [ 3389 ];
  networking.firewall.allowedUDPPorts = [ 3389 ];
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "${pkgs.gnome.gnome-session}/bin/gnome-session";
  services.xrdp.openFirewall = true;

  #virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    league-of-moveable-type
    hunspell
    hunspellDicts.de_DE
    #virt-manager
  ];

  services.syncthing = {
    enable = true;
    user = "kevin";
    dataDir = "/home/kevin/Syncthing";
    configDir = "/home/kevin/Syncthing/.config/syncthing";
  };

  #services.fwupd.enable = true;
  #hardware.cpu.intel.updateMicrocode = true;

  boot.supportedFilesystems = [ "ntfs" ];

  services.printing.enable = true;
  virtualisation.docker.enable = true;
  
  #services.xserver.videoDrivers = [ "nvidia" ];
  #hardware.opengl.enable = true;

  #services.clamav.daemon.enable = true;
  #services.clamav.updater.enable = true;

  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;

  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };

  #programs.wireshark.enable = true;
  #users.users.kevin.extraGroups = [ "wireshark" ];

  networking.hostName = "workspace";
  networking.hostId   = "6599a272";

  system.stateVersion = "23.05"; # No touchy. Locks defaults.
}
