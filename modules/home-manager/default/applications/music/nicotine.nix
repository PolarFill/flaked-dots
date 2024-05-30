{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.music.nicotine;
  in {
    options.homeModules.default.applications.music.nicotine = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Sets up nicotine, a soulseek graphical client!";
      };

    };

  config = lib.mkIf cfg.enable {   
    
    home.packages = with pkgs; [
      nicotine-plus
    ];


  }; 
} 
