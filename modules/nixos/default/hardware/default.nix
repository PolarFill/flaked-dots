{ config, ... }:

let
  cfg = config.modules.hardware;
in {

  imports = [
    ./nvidia.nix
    ./storageDrives.nix
  ];

}
