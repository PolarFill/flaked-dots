{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.misc.xdragon;
  in {
    options.homeModules.default.applications.misc.xdragon = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Cool utility to drag-and-drop from any terminal!";
      };
    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
      xdragon
    ];
  };
}

# yeah thats it lol
