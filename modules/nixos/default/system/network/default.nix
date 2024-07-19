{ config, ... }:

let
  cfg = config.modules.system.network;
in {

  imports = [
    ./ssh/ssh.nix
    ./wireless.nix
  ];

}
