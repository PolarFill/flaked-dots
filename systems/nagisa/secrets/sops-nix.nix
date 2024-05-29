{ inputs, pkgs, lib, config, ... }:

{
  sops = {

    defaultSopsFile = ./age_secrets/default_secrets.yaml;
    defaultSopsFormat = "yaml";
#    defaultSymlinkPath = "/run/user/1000/secrets";
#    defaultSecretsMountPoint = "/run/user/1000/secrets";

    age.keyFile = "/home/skynet/.config/sops/age/keys.txt";
  
    secrets = {
      "auths/lastfm/password" = {};
      "auths/lastfm/user" = {};

      "conf_template" = { sopsFile = ./age_secrets/lastfm_secrets.yaml; };

      #"skynet/password" = {
      #  neededForUsers = true;
      #};
    };
  };
}

