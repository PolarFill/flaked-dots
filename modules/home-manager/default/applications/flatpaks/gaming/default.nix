{ config, ... }:

let
  cfg = config.modules.applications.flatpaks.gaming; 
in {
  imports = [
    ./steam.nix
    ./sober/sober.nix
    ./mcpe-launcher.nix
    ./pokemmo/pokemmo.nix
  ];
}
