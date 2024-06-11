{ config, ... }:

let
  cfg = config.modules.applications.term.dev;
in {
  imports = [
    ./python/python.nix
    ./git.nix
  ];
}


