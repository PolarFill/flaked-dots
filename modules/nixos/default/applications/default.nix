{ config, ... }:

let
  cfg = config.modules.applications;
in {

  imports = [
    ./steam.nix
    ./misc
    ./management
  ];
}
