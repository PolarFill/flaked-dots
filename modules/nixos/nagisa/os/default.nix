{ config, ... }:

let
  cfg = config.modules.os;
in {

  imports = [
    ./xdph.nix
    ./nix-config.nix
  ];
}
