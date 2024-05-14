{ config, ... }:

let
  cfg = config.modules.dev;
in {
  imports = [
    ./python/python.nix
  ];
}


