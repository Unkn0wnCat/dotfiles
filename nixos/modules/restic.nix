{ pkgs, lib, config, ... }: {
  environment.systemPackages = with pkgs; [
    restic
  ];

  users.users.restic = {
    isNormalUser = true;
    extraGroups = [ config.users.groups.keys.name ];
  };

  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = config.users.users.restic.name;
    group = config.users.users.restic.group;
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };


  environment.etc = {
    "restic/backup-exclude.list" = {
        source = ../../restic/backup-exclude.list;
    };
    "restic/backup-iexclude.list" = {
        source = ../../restic/backup-iexclude.list;
    };
    "restic/backup.list" = {
        source = ../../restic/backup.list;
    };
    "restic/backup.sh" = {
        source = ../../restic/backup.sh;
    };
  };

  sops.secrets."restic/password" = {
    sopsFile = ../shared/secrets/restic.yaml;
    owner = config.users.users.restic.name;
    mode = "0400";
  };

  sops.secrets."restic/repository" = {
    sopsFile = ../shared/secrets/restic.yaml;
    owner = config.users.users.restic.name;
    mode = "0400";
  };

  sops.secrets."restic/aws_id" = {
    sopsFile = ../shared/secrets/restic.yaml;
    owner = config.users.users.restic.name;
    mode = "0400";
  };

  sops.secrets."restic/aws_secret" = {
    sopsFile = ../shared/secrets/restic.yaml;
    owner = config.users.users.restic.name;
    mode = "0400";
  };
}