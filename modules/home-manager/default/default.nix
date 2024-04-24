{ config, ... }:

let
  cfg = config.modules;
in {
  imports = [
    ./shell
    ./applications
    ./system
  ];
}


