{
  imports = [ ./ssh.nix ];

  users.users.kevin = {
    isNormalUser = true;
    description = "Kevin Kandlbinder";
    extraGroups = [ "wheel" "docker" "dialout" "networkmanager" "floppy" "audio" "lp" "cdrom" "tape" "video" "render" ]; 
  };
  
  kevin.ssh.authorized.kevin.users = ["kevin" "root"];
}