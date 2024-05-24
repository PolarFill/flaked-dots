{ config, ... }:

let
  cfg = config.modules;
in {
  imports = [
    ./hardware
    ./os
    ./applications
  ];
}
