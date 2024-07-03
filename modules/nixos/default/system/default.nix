{ config, ... }:

let
  cfg = config.modules.system;
in {

  imports = [
    ./kernel.nix
    ./localization.nix
    ./security
  ];

}
