{ config, ... }:

let
  cfg = config.modules;
in {
  imports = [
    ./scripts
    ./shell
    ./applications
    ./system
  ];
}


