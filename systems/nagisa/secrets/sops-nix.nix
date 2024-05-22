{ inputs, pkgs, lib, config, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {

    defaultSopsFile = ./age_secrets/default_secrets.yaml;
    defaultSopsFormat = "yaml";
  
    age.keyFile = "/home/skynet/.config/sops/age/keys.txt";
  
   # secrets = {
   #   "auth/lastfm/password" = {
   #     owner = "skynet";
   #   };

   #   "skynet" = {
   #     owner = "skynet";
   #   };

    };
}

