{ config, ... }:

let
  cfg = config.modules.shell.dev;
in {
  imports = [
    ./git.nix
  ];
}


