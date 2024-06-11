{inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.term.utils.zathura;
  in {
    options.homeModules.default.applications.term.utils.zathura = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables and configures zathura reader!";
      };

      theme = lib.options.mkOption {
        default = null;
	type = lib.types.nullOr lib.types.str;
	description = "Sets the application theme";
      };

    };

  config = lib.mkIf cfg.enable {   

    programs.zathura = {
      
      enable = true;
      
      extraConfig = lib.mkIf ( cfg.theme != null ) ''
        include ${cfg.theme}
      '';
    
    };

    home.file = lib.mkIf (cfg.theme != null) {
      zathuraTheme = {
        target = ".config/zathura/${cfg.theme}";
	source = ./themes/${cfg.theme};
      };
    };

    home.shellAliases = {
      zth = "zathura";
    };

  };
}
