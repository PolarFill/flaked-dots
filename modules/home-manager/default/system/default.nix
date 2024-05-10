{ config, ... }:

let
  cfg = config.modules.system;
in {
  imports = [
    ./graphics
    ./xdg
    ./fonts.nix
    ./ui
  ];
}
