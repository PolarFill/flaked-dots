{ config, ... }:

let
  cfg = config.modules.os;
in {

  imports = [
    ./pipewire.nix
    ./fonts.nix
  ];
}
