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
      ../modules/gaming/steam.nix
      ../modules/gaming/helpers.nix
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

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    league-of-moveable-type
    hunspell
    hunspellDicts.de_DE
    virt-manager
  ];

  services.syncthing = {
    enable = true;
    user = "kevin";
    dataDir = "/home/kevin/Syncthing";
    configDir = "/home/kevin/Syncthing/.config/syncthing";
  };

  services.fwupd.enable = true;
  hardware.cpu.intel.updateMicrocode = true;

  boot.supportedFilesystems = [ "ntfs" ];

  services.printing.enable = true;
  virtualisation.docker.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;

  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };

  networking.hostName = "kevin-pc";
  networking.hostId   = "5dbf8235";

  system.stateVersion = "23.05"; # No touchy. Locks defaults.
}
