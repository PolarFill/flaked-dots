{ config, ... }:

let
  cfg = config.modules.system;
in {

  imports = [
    ./kernel.nix
    ./localization.nix
    ./oom-killer.nix
    ./virtualisation
    ./security
    ./network
  ];

}
