{ config, lib, pkgs, ... }:

  let
    cfg = config.homeModules.default.applications.social.discord;

    mods_enabled =       
      cfg.mods.equicord.enable ||
      cfg.mods.vencord.enable ||
      cfg.mods.shelter.enable;

  in lib.mkIf ( cfg.mods.enable == true && cfg.mods.client == "legcord" ) {

    xdg.configFile."legcord/storage/HomeManagerInit_config.json" = {
      text = builtins.toJSON {
	client_type = cfg.branch;
	minimizeToTray = false;
	mods = 
	  []
	  ++ lib.lists.optional ( cfg.mods.vencord.enable ) "vencord"
	  ++ lib.lists.optional ( cfg.mods.equicord.enable ) "equicord"
	  ++ lib.lists.optional ( cfg.mods.shelter.enable ) "shelter";
      };
      onChange = ''  
        rm -f ${config.xdg.configHome}/legcord/storageconfig.json
        cp ${config.xdg.configHome}/legcord/storage/HomeManagerInit_config.json ${config.xdg.configHome}/legcord/storage/config.json
        chmod u+w ${config.xdg.configHome}/legcord/storage/config.json
      '';
    };

/*
    home.file.manifest_json = lib.mkIf mods_enabled {
      target = "${config.xdg.configHome}/legcord_hm/manifest.json";
      source =  ./plugins/loader_extension/manifest.json;
    };

    home.file.content_js = lib.mkIf mods_enabled {
      target = "${config.xdg.configHome}/legcord_hm/content.js";
      source =  ./plugins/loader_extension/content.js;
    };
*/

  }
