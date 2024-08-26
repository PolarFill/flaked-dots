{ config, ... }:

let
  cfg = config.modules.applications.flatpaks; 
in {
  imports = [
    ./flatpak.nix
    ./bottles.nix
    ./gaming
  ];
}
