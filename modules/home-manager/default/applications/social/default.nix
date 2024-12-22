{ config, ... }:

let
  cfg = config.modules.applications.social; 
in {
  imports = [
    ./discord
  ];
}
