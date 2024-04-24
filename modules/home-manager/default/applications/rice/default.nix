{ config, ... }:

let
  cfg = config.modules.applications.rice; 
in {
  imports = [
    ./wofi/wofi.nix
  ];
}
