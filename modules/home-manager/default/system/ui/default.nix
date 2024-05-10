{ config, ... }:

let
  cfg = config.modules.system.ui;
in {
  imports = [
    ./mako/mako.nix
  ];
}
