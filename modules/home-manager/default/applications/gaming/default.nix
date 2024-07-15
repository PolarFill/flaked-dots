{ config, ... }:

let
  cfg = config.modules.applications.gaming; 
in {
  imports = [
    ./minecraft
  ];
}
