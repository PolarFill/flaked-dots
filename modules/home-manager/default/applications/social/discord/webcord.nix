{ config, lib, pkgs, ... }:

  let
    cfg = config.homeModules.default.applications.social.discord;
  in lib.mkIf ( cfg.mods.enable == true && cfg.mods.client == "webcord" ) {

    home.packages = [
      pkgs.webcord
    ];

    xdg.configFile."webcord/HomeManagerInit_config.json" = {
      text = builtins.toJSON {
	settings = {
	  general.tray.disable = true;
	  privacy = {
	    blockApi = {
	      science = true;
	      typingIndicator = true;
	      fingerprinting = true;
	    };
	  };
	  advanced = {
	    currentInstance = 
	      if cfg.branch == "stable" then 0 else
	      if cfg.branch == "canary" then 1 else 2;
	  };
	 };
         minimizeToTray = "off";
      };
      onChange = ''  
        rm -f ${config.xdg.configHome}/webcord/settings.json
        cp ${config.xdg.configHome}/webcord/HomeManagerInit_config.json ${config.xdg.configHome}/webcord/config.json
        chmod u+w ${config.xdg.configHome}/dorion/config.json
      '';
    };

  }
