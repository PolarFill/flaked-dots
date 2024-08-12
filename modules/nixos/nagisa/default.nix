{ config, ... }:

let
  cfg = config.modules;
in {
  imports = [
    ./os
  ];
}
