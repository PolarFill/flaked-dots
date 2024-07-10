{ config, ... }:

let
  cfg = config.modules.applications.term.utils;
in {
  imports = [
    ./nvim.nix
    ./nixvim/plugins/barbar.nix
  ];
}
