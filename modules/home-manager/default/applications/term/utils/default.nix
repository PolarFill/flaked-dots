{ config, ... }:

let
  cfg = config.modules.applications.term.utils;
in {
  imports = [
    ./btop/btop.nix
  ];
}
