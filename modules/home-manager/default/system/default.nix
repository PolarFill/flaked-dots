{ config, ... }:

let
  cfg = config.modules.system;
in {
  imports = [
    ./graphics
    ./xdg
    ./ui
    ./misc
  ];
}
