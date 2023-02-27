{ pkgs, lib, ... }: {
  imports = [ ./ssh.nix ];

  nixpkgs.config.allowUnfree = true;
  i18n.defaultLocale = "en_US.UTF-8";
  kevin.ssh.server.enable = true;

  time.timeZone = lib.mkDefault "Europe/Berlin";

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}