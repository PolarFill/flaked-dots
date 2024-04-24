{ config, ... }:

let
  cfg = config.modules.system.xdg;
in {
  imports = [
    ./portals.nix
  ];
}
