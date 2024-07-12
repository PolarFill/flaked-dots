{ inputs, pkgs, lib, config, ... }:

{
  sops = {

    defaultSopsFile = ./age_secrets/default_root-secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/var/lib/sops-nix/keys.txt";
  
    secrets = {
      "ssh-keys/private" = { owner = "skynet"; };      
    };
  };
}

