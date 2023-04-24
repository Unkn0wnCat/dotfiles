{pkgs, ...}:
{
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.enableExcludeWrapper = false;
}
