{ config, lib, ... }:

let
  cfg = config.modules.applications.web.firefox;
in {
  imports = [
    ./firefox.nix
    ./bookmarks/vtubers.nix
  ];

}
