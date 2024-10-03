{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.flatpaks.utils.sysdvr;
  in {
    options.homeModules.default.applications.flatpaks.utils.sysdvr = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables sysdvr client flatpak for streaming switch's screen!";
      };

    };

  config = lib.mkIf cfg.enable {   
    
    services.flatpak.packages = [
      "flathub:app/io.github.parnassius.SysDVR-Qt//stable" 
    ];

  }; 
}
