{ config, ... }:

let
  cfg = config.modules.applications.gaming.minecraft; 
in {
  imports = [
    ./prismlauncher.nix
  ];
}
