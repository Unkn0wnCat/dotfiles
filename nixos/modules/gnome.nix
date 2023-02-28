{pkgs, ...}:
{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.flatpak.enable = true;

  environment.systemPackages = [
    pkgs.gnome.gnome-tweaks
    pkgs.gnome.dconf-editor
    pkgs.gnome.gnome-tweaks
  ];
}