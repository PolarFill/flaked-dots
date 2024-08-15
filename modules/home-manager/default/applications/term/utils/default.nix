{ config, ... }:

let
  cfg = config.modules.applications.term.utils;
in {
  imports = [
    ./timg.nix
    ./btop/btop.nix
    ./bat/bat.nix
    ./zathura/zathura.nix
    ./nvim
  ];
}
