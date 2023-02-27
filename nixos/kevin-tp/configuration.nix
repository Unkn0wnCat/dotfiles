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
      ../modules/power/thinkpad.nix
      ../modules/yubikey.nix
    ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.example-key = {};


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-uuid/0412bb67-c6c7-42fd-a532-ced413d1203d";
      preLVM = true;
    };
  };

  boot.initrd.kernelModules = [
    "aesni_intel"
    "cryptd"
    "essiv"
  ];

  networking.hostName = "kevin-tp";
  networking.hostId   = "2d62d680";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    league-of-moveable-type
    hunspell
    hunspellDicts.de_DE
  ];

  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };

  services.xserver.libinput.enable = true;

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    libvdpau-va-gl
    intel-media-driver
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 1;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_background_ratio" = 20;
    "vm.dirty_ratio" = 50;
    # these are the zen-kernel tweaks to CFS defaults (mostly)
    "kernel.sched_latency_ns" = 4000000;
    # should be one-eighth of sched_latency (this ratio is not
    # configurable, apparently -- so while zen changes that to
    # one-tenth, we cannot):
    "kernel.sched_min_granularity_ns" = 500000;
    "kernel.sched_wakeup_granularity_ns" = 50000;
    "kernel.sched_migration_cost_ns" = 250000;
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "kernel.sched_nr_migrate" = 128;
  };

  systemd = {
    extraConfig = ''
      DefaultCPUAccounting=yes
      DefaultMemoryAccounting=yes
      DefaultIOAccounting=yes
    '';
    user.extraConfig = ''
      DefaultCPUAccounting=yes
      DefaultMemoryAccounting=yes
      DefaultIOAccounting=yes
    ''; 
    services."user@".serviceConfig.Delegate = true;
  };

  systemd.services.nix-daemon.serviceConfig = {
    CPUWeight = 20;
    IOWeight = 20;
  };

  boot.kernelParams = ["cgroup_no_v1=all" "systemd.unified_cgroup_hierarchy=yes"];

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

  
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  #kevin.defaults = "laptop";

  #system.copySystemConfiguration = true;

  system.stateVersion = "23.05"; # No touchy. Locks defaults.

}
