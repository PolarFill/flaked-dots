{ config, ... }:

let
  cfg = config.modules.applications.management;
in {

  imports = [
    ./doas.nix
  ];
}
