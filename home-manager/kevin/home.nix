{pkgs, ...}: {
  home.stateVersion = "23.05"; # No touchy. Locks defaults.

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
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
    thunderbird-bin
    vlc
    gimp
    blender
    libreoffice-fresh
    yt-dlp
    yarn
    nodejs
    neofetch
    inkscape-with-extensions
    jetbrains.goland
    jetbrains.idea-ultimate
    gnomeExtensions.gsconnect
  ];

  home.language = {
    base = "en_US";
    
    address = "de_DE";
    measurement = "de_DE";
    monetary = "de_DE";
    name = "de_DE";
    paper = "de_DE";
    telephone = "de_DE";
    time = "de_DE";
  };

  home.sessionVariables = {
    LD_LIBRARY_PATH = "/var/run/current-system/sw/lib";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "svim" = "sudo vim";
  };

  manual.html.enable = true;
  manual.manpages.enable = true;

  nix.settings = {
    sandbox = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.aria2.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = [ ];
  };

  programs.watson = {
    enable = true;
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
