{ config, ... }:

let
  cfg = config.modules.applications.flatpaks.utils; 
in {
  imports = [
    ./sysdvr.nix
  ];
}
