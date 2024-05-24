{ inputs, pkgs, lib, config, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {

    defaultSopsFile = ./age_secrets/default_secrets.yaml;
    defaultSopsFormat = "yaml";
  
    age.keyFile = "/home/skynet/.config/sops/age/keys.txt";
  
    secrets = {
      "auths/lastfm/password" = {
        owner = "skynet";
      };

      "auths/lastfm/user" = {
        owner = "skynet";
      };

      "skynet/password" = {
        neededForUsers = true;
      };
    };
  };
}

