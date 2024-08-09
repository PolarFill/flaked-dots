{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.flatpaks.sober;
  in {
    options.homeModules.default.applications.flatpaks.sober = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables sober roblox compat layer for linux!";
      };

    };

  config = lib.mkIf cfg.enable {   
    
    services.flatpak.packages = [
      { appId = "org.vinegarhq.Sober"; }
    ];

  }; 
}
