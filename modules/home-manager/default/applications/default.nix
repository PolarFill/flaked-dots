{ config, ... }:

let
  cfg = config.modules.applications; 
in {
  imports = [
    ./social
    ./term
    ./web
    ./misc
    ./rice
    ./music
    ./flatpaks
  ];
}
