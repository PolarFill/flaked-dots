{ config, ... }:

let
  cfg = config.modules.shell;
in {
  imports = [
    ./fish/fish.nix
    ./shell-utils.nix
    ./shellFun.nix
  ];
}


