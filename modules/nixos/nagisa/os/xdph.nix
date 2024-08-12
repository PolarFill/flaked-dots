{ config, lib, pkgs, ... }:

let
  cfg = config.nixosModules.nagisa.os.xdph;
in {
  options.nixosModules.nagisa.os.xdph = {
    enable = lib.options.mkEnableOption {
      default = false;
      type = lib.types.bool;
      description = "Sets up xdph at system level";
    };
  };

config = lib.mkIf cfg.enable {

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [ "*" ];
	"org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
    extraPortals = [
      #inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
#      inputs.hyprland-portal.packages.${pkgs.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

};
}
