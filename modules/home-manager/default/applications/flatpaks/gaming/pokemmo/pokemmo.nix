# This module does NOT provide the roms required to play PokeMMO
# due to this config being hosted in pubicly-acessible places 
# and the roms being heavy as fuck (200mb, aint bloating my conf with that)

{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.flatpaks.gaming.pokemmo;
  in {
    options.homeModules.default.applications.flatpaks.gaming.pokemmo = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Installs pokemmo, a mmo based on pokemon!";
      };
/*      
      compositor = lib.options.mkOption {
        default = "X11";
	type = lib.types.enum [ "X11" "Wayland" ];
        description = ''Specifies the compositor you're using (wayland or xorg)
			I couldn't get wayland to work on my machine though? Procede with caution'';
      };

      graphics = {

	framerate = lib.options.mkOption {
	  default = "144";
	  type = lib.types.str;
	  description = "Sets the maximum framerate of the game";
	};

	msaa_level = lib.options.mkOption {
	  default = "16";
	  type = lib.types.enum [ "0" "2" "4" "8" "16" ];
	  description = "Sets the level of antialiasing that should be applied";
	};

	hq_shaders = lib.options.mkOption {
	  default = true;
	  type = lib.types.bool;
	  description = "Chooses if the shaders should be on \"High\" or \"Low\"";
	};

      };

      gameplay = {
	text_speed = lib.options.mkOption {
	  default = "5";
	  type = lib.types.str;
	  description = "Sets the text speed, with 6 being instant";
	};
      };
*/
    };

  config = lib.mkIf cfg.enable {   
    
    services.flatpak.packages = [
      "flathub:app/com.pokemmo.PokeMMO//stable"
    ];
/*
    home.file.".var/app/com.pokemmo.PokeMMO/data/pokemmo-client-live/hm_main.properties" = {

      text = lib.generators.toINIWithGlobalSection {} {
	globalSection = {
	  "client.gameplay.text_speed" = cfg.gameplay.text_speed;

	  "client.graphics.linux.preferred_compositor" = cfg.compositor;
	  "client.graphics.max_fps" = cfg.graphics.framerate;
	  "client.graphics.msaa_samples" = cfg.graphics.msaa_level;
	  "client.graphics.shader_quality" = if cfg.graphics.hq_shaders == true then "1" else "0";
	};
      };

      onChange = ''
	rm -f .var/app/com.pokemmo.PokeMMO/data/pokemmo-client-live/config/main.properties
        cp .var/app/com.pokemmo.PokeMMO/data/pokemmo-client-live/hm_main.properties .var/app/com.pokemmo.PokeMMO/data/pokemmo-client-live/config/main.properties
        chmod u+w .var/app/com.pokemmo.PokeMMO/data/pokemmo-client-live/config/main.properties
      '';
    };
*/
    

  }; 
}
