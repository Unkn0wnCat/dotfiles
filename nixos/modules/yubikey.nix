{ pkgs, ... }: {
  security.pam.yubico = {
    enable = true;
    debug = false;
    mode = "challenge-response";
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];
}