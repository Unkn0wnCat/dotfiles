{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../modules/server/docker.nix
    ];
    
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "amon";
  networking.domain = "srv.1in9.net";
  
  time.timeZone = "Europe/Berlin";
  
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  users.users.kevin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
    git
  ];

  sops.secrets.cloudflare_api_token = {
    sopsFile = ./secrets/acme.yaml;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "kevin@1in9.net";
    certs."amon.srv.1in9.net" = {
      dnsProvider = "cloudflare";
      credentialsFile = "/run/secrets/cloudflare_api_token";
    };
    certs."amon.mx.1in9.net" = {
      dnsProvider = "cloudflare";
      credentialsFile = "/run/secrets/cloudflare_api_token";
      group = config.services.maddy.group;
    };
  };


  services.maddy = {
      enable = true;
      primaryDomain = "amon.1in9.net";
      hostname = "amon.mx.1in9.net";
      localDomains = [
        "$(primary_domain)"
      ];
      openFirewall = true;

      config = ''
  $(relay_domains) = kevink.dev 1in9.net 1in1.net
  
  tls file /var/lib/acme/$(hostname)/fullchain.pem /var/lib/acme/$(hostname)/key.pem
  
  auth.pass_table local_authdb {
    table sql_table {
      driver sqlite3
      dsn credentials.db
      table_name passwords
    }
  }
  
  storage.imapsql local_mailboxes {
    driver sqlite3
    dsn imapsql.db
  }
  
  table.chain local_rewrites {
    optional_step regexp "(.+)\+(.+)@(.+)" "$1@$3"
    optional_step static {
      entry postmaster postmaster@$(primary_domain)
    }
    optional_step file /etc/maddy/aliases
  }

  msgpipeline local_routing {
    destination postmaster $(local_domains) {
      modify {
        replace_rcpt &local_rewrites
      }
      deliver_to &local_mailboxes
    }
    default_destination {
      reject 550 5.1.1 "User doesn't exist"
    }
  }

  msgpipeline relay {
    destination $(relay_domains) {
      deliver_to &remote_queue
    }
    default_destination {
      reject 550 5.1.1 "We do not relay for this domain"
    }
  }
  
  smtp tcp://0.0.0.0:25 {
    limits {
      all rate 20 1s
      all concurrency 10
    }
    dmarc yes
    check {
      require_mx_record
      dkim
      spf
    }
    source $(local_domains) {
      reject 501 5.1.8 "Use Submission for outgoing SMTP"
    }
    default_source {
      destination postmaster $(local_domains) {
        deliver_to &local_routing
      }
      destination $(relay_domains) {
        deliver_to &relay
      }
      default_destination {
        reject 550 5.1.1 "User doesn't exist"
      }
    }
  }
  
  submission tcp://0.0.0.0:587 {
    limits {
      all rate 50 1s
    }
    auth &local_authdb
    source $(local_domains) {
      check {
          authorize_sender {
              prepare_email &local_rewrites
              user_to_email identity
          }
      }
      destination postmaster $(local_domains) {
          deliver_to &local_routing
      }
      default_destination {
          modify {
              dkim $(primary_domain) $(local_domains) default
          }
          deliver_to &remote_queue
      }
    }
    default_source {
      reject 501 5.1.8 "Non-local sender domain"
    }
  }
  
  target.remote outbound_delivery {
    limits {
      destination rate 20 1s
      destination concurrency 10
    }
    mx_auth {
      dane
      mtasts {
        cache fs
        fs_dir mtasts_cache/
      }
      local_policy {
          min_tls_level encrypted
          min_mx_level none
      }
    }
  }
  
  target.queue remote_queue {
    target &outbound_delivery
    autogenerated_msg_domain $(primary_domain)
    bounce {
      destination postmaster $(local_domains) {
        deliver_to &local_routing
      }
      default_destination {
          reject 550 5.0.0 "Refusing to send DSNs to non-local addresses"
      }
    }
  }
  
  target.remote relay_delivery {
    limits {
      destination rate 20 1s
      destination concurrency 10
    }
    mx_auth {
      dane
      mtasts {
        cache fs
        fs_dir mtasts_cache/
      }
      local_policy {
          min_tls_level encrypted
          min_mx_level none
      }
    }
  }
  
  target.queue relay_queue {
    target &relay_delivery
    autogenerated_msg_domain $(primary_domain)
    bounce {
      destination postmaster $(local_domains) {
        deliver_to &local_routing
      }
      default_destination {
        # Return DSN to sender using outbound queue
        deliver_to &remote_queue
      }
    }
  }
  
  imap tcp://0.0.0.0:143 {
    auth &local_authdb
    storage &local_mailboxes
  }
'';
  };

  system.stateVersion = "22.11"; # No touchy.

}