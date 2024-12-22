{ config, lib, pkgs, ... }:

  let
    cfg = config.homeModules.default.applications.social.discord;

    # Dorion requires shelter to work properly
    mod_list = 
      []
      ++ lib.lists.optional ( cfg.mods.equicord.enable ) "Equicord"
      ++ lib.lists.optional ( cfg.mods.vencord.enable ) "Vencord"
      ++ [ "Shelter" ];

/*
      filtered_list = lib.lists.remove "bd" cfg.mods.mod_injection;
      capitalized_list = lib.lists.forEach filtered_list ( x: capitalize x );
    in
      if ( builtins.elem "Shelter" capitalized_list )
      then capitalized_list ++ [ "Shelter" ]
      else capitalized_list;
*/

  in lib.mkIf ( cfg.mods.enable == true && cfg.mods.client == "dorion" ) {

    home.packages = [
      # TODO: Use https://github.com/NixOS/nixpkgs/pull/265771 when its merged
      # into master
      pkgs.dorion 
    ];

    xdg.configFile."dorion/HomeManagerInit_config.json" = {
      text = builtins.toJSON {

	# "stable" branch (the default one) is called default,
	# but the option values and dorion values match in all other cases
	client_type = if cfg.branch == "stable" then "default" else cfg.branch;
	sys_tray = false;
	block_telemetry = true;
	cache_css = true;
	client_mods = mod_list;
      };
      onChange = ''  
        rm -f ${config.xdg.configHome}/dorion/config.json.json
        cp ${config.xdg.configHome}/dorion/HomeManagerInit_config.json ${config.xdg.configHome}/dorion/config.json
        chmod u+w ${config.xdg.configHome}/dorion/config.json
      '';
    };

    home.file.bd_browser = lib.mkIf ( cfg.mods.betterdiscord.enable ) {
      target = "${config.xdg.configHome}/dorion/extensions/BDBrowser";
      source =	
	pkgs.fetchzip {
	  url = "https://github.com/tsukasa/BdBrowser/releases/download/v1.10.2.20240619/bdbrowser-extension-1.10.2.20240619.zip";
	  sha256 = "sha256-rH1Av2QdP1Tf9H9il8GRcNYXefT9BFQGI8e8Z0nm+QY";
	  stripRoot = false;
	};
    };

/*

    home.file.manifest_json = lib.mkIf ( 
      cfg.mods.equicord.enable ||
      cfg.mods.vencord.enable ||
      cfg.mods.shelter.enable ) 
    {
      target = "${config.xdg.configHome}/dorion_hm/manifest.json";
      source = 	./plugins/loader_extension/manifest.json;
    };

    home.file.content_js = lib.mkIf ( 
      cfg.mods.equicord.enable ||
      cfg.mods.vencord.enable ||
      cfg.mods.shelter.enable ) 
    {
      target = "${config.xdg.configHome}/dorion_hm/content.js";
      source = 	./plugins/loader_extension/content.js;
    };

*/

  }
