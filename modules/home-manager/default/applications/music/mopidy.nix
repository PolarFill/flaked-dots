{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.music.mopidy;
  in {
    options.homeModules.default.applications.music.mopidy = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Sets up mopidy!";
      };

      scrobbler = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
	description = "Activates lastfm scrobbler (warning: this uses secrets!)";
      };

    };

  config = lib.mkIf cfg.enable {   

    services.mopidy = {
      
      enable = true;
      
      extensionPackages = with pkgs; [
        mopidy-mpd
	mopidy-scrobbler
      ];
      
      settings = {

        core = {
          cache_dir = "$XDG_CACHE_DIR/mopidy";
	  data_dir = "$XDG_DATA_DIR/mopidy";
	  max_tracklist_length = 10000;
	  restore_state = true;
	};

        audio = {
          mixer = "software";
	  output = "tee name=t ! queue ! autoaudiosink t. ! queue ! audio/x-raw,rate=44100,channels=2,format=S16LE ! udpsink host=localhost port=5555";
	};

	file = {
          enabled = true;
	  media_dirs = [ "$XDG_MUSIC_DIR|Music" "~/Music" ];
	  excluded_file_extensions = [ ".jpeg" ".zip" ".jpg" ".png" ".txt" ".nfo" ".iso" ];
	  show_dotfiles = true;
	  follow_symlinks = true;
	  metadata_timeout = 1000;
	};

	mpd = {
          enabled = true;
	  hostname = "::";
	  port = 6600;
	  max_connections = 20;
	  connection_timeout = 60;
	  default_playlist_scheme = "m3u";
	  zeroconf = "MPD Service";
	};

        scrobbler = lib.mkIf ( cfg.scrobbler == true ) {
	  username = "$(cat ${config.sops.secrets."auths/lastfm/user".path})";
	  password = "$(cat ${config.sops.secrets."auths/lastfm/password".path})";
	};
      };
    };

  }; 
} 
