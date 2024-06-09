{ config, ... }:

let
  cfg = config.modules.hardware;
in {

  imports = [
    ./nvidia
    ./storageDrives.nix
  ];

}
