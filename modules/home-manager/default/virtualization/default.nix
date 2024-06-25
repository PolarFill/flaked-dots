{ config, ... }:

let
  cfg = config.modules.virtualization;
in {
  imports = [
    ./distrobox.nix
  ];
}


