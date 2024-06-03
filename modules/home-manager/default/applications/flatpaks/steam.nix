{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.flatpaks.steam;
  in {
    options.homeModules.default.applications.flatpaks.steam = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables steam flatpak!";
      };

    };

  config = lib.mkIf cfg.enable {   

   services.flatpak.enable = true;

   services.flatpak.packages = [
     { appId = "com.valvesoftware.Steam"; origin = "flathub-beta"; }
   ];

  }; 
}
