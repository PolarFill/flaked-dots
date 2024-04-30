{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.misc.mangohud;
  in {
    options.homeModules.default.applications.misc.mangohud = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Usefull afterburner-like stats for games!";
      };
    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
      mangohud
    ];

    programs.mangohud = { 
      settings = {
        full = true;
      };
    };   
  };
}
