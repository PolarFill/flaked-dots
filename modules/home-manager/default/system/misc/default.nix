{ config, ... }:

let
  cfg = config.modules.system.misc;
in {
  imports = [
    ./fonts.nix
  ];
}
