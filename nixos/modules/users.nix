{config, ...}: {
  imports = [ ./ssh.nix ];

  sops.secrets.password_kevin = {
    neededForUsers = true;
    sopsFile = ../shared/secrets/passwords.yaml;
  };


  users.mutableUsers = false;

  users.users.kevin = {
    isNormalUser = true;
    description = "Kevin Kandlbinder";
    extraGroups = [ "wheel" "docker" "dialout" "networkmanager" "floppy" "audio" "lp" "cdrom" "tape" "video" "render" ]; 
    passwordFile = config.sops.secrets.password_kevin.path;
  };
  
  kevin.ssh.authorized.kevin.users = ["kevin" "root"];
}