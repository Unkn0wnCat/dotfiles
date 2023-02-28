{pkgs, ...}: {
  home.stateVersion = "23.05"; # No touchy. Locks defaults.

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings = {
        aliases = {
          "clone" = "repo clone";
        };

        editor = "vim";
        git_protocol = "https";
        prompt = "enabled";
    };
  };

  programs.git = {
    enable = true;

    aliases = {};

    diff-so-fancy.enable = true;

    lfs.enable = true;

    signing.signByDefault = true;
    signing.key = null;

    userEmail = "kevin@kevink.dev";
    userName = "Kevin Kandlbinder";
  };

  programs.go = {
    enable = true;
  };

  programs.gpg = {
    enable = true;
  };

  #programs.thunderbird.enable = true;

  home.packages = with pkgs; [
    signal-desktop
    discord 
    element-desktop
    vscode
    thunderbird
    vlc
    gimp
    blender
    libreoffice-fresh
  ];
}