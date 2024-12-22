{ config, ... }:

let
  cfg = config.modules.applications.social.discord; 
in {
  imports = [
    ./discord.nix
    ./vesktop.nix
    ./equibop.nix
    ./webcord.nix
    ./dorion.nix
    ./legcord.nix
  ];
}
