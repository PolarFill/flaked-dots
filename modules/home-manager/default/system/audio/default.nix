{ config, ... }:

let
  cfg = config.modules.system.audio;
in {
  imports = [
    ./mopidy.nix
  ];
}
