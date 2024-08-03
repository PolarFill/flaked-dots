{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.flatpaks.bottles;
  in {
    options.homeModules.default.applications.flatpaks.bottles = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables bottles!";
      };

    };

  config = lib.mkIf cfg.enable {   
    
    services.flatpak.packages = [
      { appId = "com.usebottles.bottles"; origin = "flathub"; }
    ];

  }; 
}
