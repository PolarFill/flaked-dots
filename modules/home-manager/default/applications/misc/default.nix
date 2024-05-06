{ config, ... }:

let
  cfg = config.modules.applications.misc;
in {
  imports = [
    ./xdragon.nix
    ./mangohud.nix
    ./libreoffice.nix
  ];
}


