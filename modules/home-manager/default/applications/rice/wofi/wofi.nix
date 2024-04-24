{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.rice.wofi;
  in {
    options.homeModules.default.applications.rice.wofi = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Sets up wofi!";
      };

      theme = lib.options.mkOption {
        default = "default";
	type = lib.types.str;
	description = "Sets the theme for wofi";
      };
    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
      wofi
    ];

    programs.wofi = with lib; {
      enable = true;
      style = ''
        ${ if cfg.theme != "default" then builtins.readFile ./themes/${cfg.theme}.css else "" }

        window { backdrop-filter: blur(10px); }

	'';
      settings = {
        allow_markup = true;
	allow_images = true;
	hide_scroll = true;
	parse_search = true;
      };
    };
  };
}
