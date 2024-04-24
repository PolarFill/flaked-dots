{ config, ... }:

let
  cfg = config.modules.system.graphics;
in {
  imports = [
    ./hyprland/hyprland.nix
    ./hyprcursor/hyprcursor.nix
    ./gtk/gtk.nix
  ];
}
