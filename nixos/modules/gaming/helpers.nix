{pkgs, ...}:
{
    environment.systemPackages = with pkgs; [
        mangohud
    ];
    programs.gamemode.enable = true;
}