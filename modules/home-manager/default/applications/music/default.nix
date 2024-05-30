{ config, ... }:

let
  cfg = config.modules.applications.music; 
in {
  imports = [
    ./mopidy.nix
    ./mpd.nix
    ./ncmpcpp.nix
    ./nicotine.nix
  ];
}
