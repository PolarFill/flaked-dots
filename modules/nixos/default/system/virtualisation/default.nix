{ config, ... }:

let
  cfg = config.modules.system.virtualisation;
in {

  imports = [
    ./single-gpu.nix
  ];

}
