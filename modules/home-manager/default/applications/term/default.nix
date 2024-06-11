{ config, ... }:

let
  cfg = config.modules.applications.term; 
in {
  imports = [
    ./alacritty/alacritty.nix
    ./utils
    ./dev
  ];
}
