{ inputs, pkgs, lib, config, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  
    age.keyFile = "/home/${cfg.user}/.config/sops/age/keys.txt";
  
    secrets = {
      "age_secrets/lastfm_secrets.yaml" = {
        owner = "skynet";
      };
      "age_secrets/user_secrets.yaml" = {
        owner = "skynet";
      };
    };
  };
}
