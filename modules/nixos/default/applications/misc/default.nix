{ config, ... }:

let
  cfg = config.nixosModules.applications.misc;
in {

  imports = [
    ./sunshine.nix
    ./ns-usbloader.nix
  ];
}
