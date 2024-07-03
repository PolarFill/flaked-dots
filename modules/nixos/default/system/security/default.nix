{ config, ... }:

let
  cfg = config.modules.system.security;
in {

  imports = [
    ./apparmor.nix
  ];

}
