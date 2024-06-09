{ config, ... }:

let
  cfg = config.modules.hardware.nvidia;
in {

  imports = [
    ./nvidia.nix
    ./nouveau.nix
  ];

}
