{ config, ... }:

let
  cfg = config.modules.applications.web; 
in {
  imports = [
    ./firefox
    ./qbittorrent/qbittorrent.nix
  ];
}
