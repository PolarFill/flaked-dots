{ config, ... }:

let
  cfg = config.modules.applications.web; 
in {
  imports = [
    ./firefox/firefox.nix
    ./qbittorrent/qbittorrent.nix
  ];
}
