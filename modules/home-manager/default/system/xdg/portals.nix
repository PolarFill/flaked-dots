# Portals allow applications to communicate via dbus interfaces under a specified
# name and object path. They are necessary for ex open default apps, share screen, etc
# This, for the time being, uses gtk for FileChooser impl without choice.

{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.system.xdg.portals;
  in {

    options.homeModules.default.system.xdg.portals = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables portals configurations";
      };
    
      defaultPortal = lib.options.mkOption {
        default = false;
	type = lib.types.str;
	description = "Specifies the default portal implementation to use (ex hyprland)";
      };
    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
       xdg-utils # Needed to open default applications
       xdg-desktop-portal
    ];

    xdg.portal = {
      enable = true;
      config = {
        common = {
	  default = [ "${cfg.defaultPortal}" ];
	  "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
	};
      };
      extraPortals = [ 
        pkgs.xdg-desktop-portal-gtk 
	inputs.hyprland-portal.packages.${pkgs.system}.xdg-desktop-portal-hyprland 
        pkgs.xdg-desktop-portal-wlr
      ];
    };
  };
}
