{ config, ... }:

let
  cfg = config.modules.os.network;
in {

  imports = [
    ./lokinet.nix
  ];
}
