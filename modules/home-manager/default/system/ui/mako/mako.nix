{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.system.ui.mako;
  in {

    options.homeModules.default.system.ui.mako = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables mako notification daemon!";
      };

      theme = lib.options.mkOption {
        default = null;
	type = lib.types.nullOr lib.types.str;
	description = "Sets mako theme";
      };

    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
      libnotify
    ];

    services.mako = {
      enable = true;
      extraConfig = "${ if (cfg.theme != null) then builtins.readFile ./themes/${cfg.theme}.conf else "" }";
      defaultTimeout = 7000;
    };
  };
}
