{inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.term.utils.bat;
  in {
    options.homeModules.default.applications.term.utils.bat = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables and configures bat, a prettier cat alternative!";
      };

      theme = lib.options.mkOption {
        default = null;
	type = lib.types.nullOr lib.types.str;
	description = "Sets the application theme";
      };

    };

  config = lib.mkIf cfg.enable {   

    programs.bat = {
      
      enable = true;
      
      extraPackages = with pkgs; [ 
        bat-extras.batgrep 
	bat-extras.batpipe 
	bat-extras.prettybat  
      ];

      config = lib.mkIf (cfg.theme != null) {
	theme = "${cfg.theme}";
      };
    
    };

    home.file = lib.mkIf (cfg.theme != null) {
      batTheme = {
        target = ".config/bat/themes/${cfg.theme}.tmTheme";
	source = ./themes/${cfg.theme}.tmTheme;
	onChange = "bat cache --build";
      };
    };

    home.sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };

    home.shellAliases = {
      cat = "bat";
      ogcat = "cat";
    };

  };
}
