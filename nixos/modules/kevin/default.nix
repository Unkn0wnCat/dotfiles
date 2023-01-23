{ lib, config, pkgs, ... }:
with lib;
let cfg = config.kevin;
in {
  imports = [
    ./power.nix
    ./networking.nix
    ./audio.nix
    ./desktop.nix
    ./yubikey.nix
    ./ssh.nix
  ];

  options.kevin = {
    defaults = mkOption {
      type = types.enum [ "none" "laptop" "desktop" ];
      default = "none";
    };
  };

  config = mkIf (cfg.defaults != "none") (mkMerge [
    ({
      nixpkgs.config.allowUnfree = true;
      i18n.defaultLocale = "en_US.UTF-8";
      kevin.ssh.server.enable = true;     
 
      console = {
        font = "Lat2-Terminus16";
        keyMap = "de";
      };

      services.xserver.layout = "de";   
   
      environment.systemPackages = with pkgs; [
        vim
        wget
        curl
        tmux
      ];
    })
    (mkIf (cfg.defaults == "laptop" || cfg.defaults == "desktop") {
      kevin.networking.enable = true;
      kevin.networking.avahi.enable = true;
      kevin.networking.firewall.wireguard = true;
      kevin.networking.firewall.kdeConnect = true;
      kevin.audio.enable = true;
      kevin.desktop.enable = true;
      kevin.desktop.type = "gnome";
      kevin.yubikey.enable = true;

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

      kevin.networking.firewall.syncthing = true;
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

      users.users.kevin = {
        isNormalUser = true;
        description = "Kevin Kandlbinder";
        extraGroups = [ "wheel" "docker" "dialout" "networkmanager" "floppy" "audio" "lp" "cdrom" "tape" "video" "render" ]; 
      };
      kevin.ssh.authorized.kevin.users = ["kevin" "root"];
    })
    (mkIf (cfg.defaults == "desktop") {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.opengl.enable = true;

      services.clamav.daemon.enable = true;
      services.clamav.updater.enable = true;
      #services.opensnitch.enable = true;
      networking.hostName = "kevin-PC";

      hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
    })
    (mkIf (cfg.defaults == "laptop") {
      kevin.power.mode = "laptop";
      networking.hostName = "kevin-tp-l580";

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
    })
  ]);
}
