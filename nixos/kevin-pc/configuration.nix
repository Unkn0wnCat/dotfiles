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
      ../modules/yubikey.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.initrd.luks.devices."luks-376a84ea-47d8-494b-aeb4-507ebac2c0fe".device = "/dev/disk/by-uuid/376a84ea-47d8-494b-aeb4-507ebac2c0fe";
  boot.initrd.luks.devices."luks-376a84ea-47d8-494b-aeb4-507ebac2c0fe".keyFile = "/crypto_keyfile.bin";

  time.hardwareClockInLocalTime = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  networking.hostName = "kevin-pc";
  networking.hostId   = "5dbf8235";

  system.stateVersion = "23.05"; # No touchy. Locks defaults.

}
