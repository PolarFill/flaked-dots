{ config, ... }:

let
  cfg = config.modules.applications.flatpaks; 
in {
  imports = [
    ./flatpak.nix
    ./steam.nix
    ./bottles.nix
  ];
}
