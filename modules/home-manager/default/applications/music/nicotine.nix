{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.music.nicotine;
  in {
    options.homeModules.default.applications.music.nicotine = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Sets up nicotine, a soulseek graphical client!";
      };

      current_user = lib.options.mkOption {
        default = "skynet";
	type = lib.types.str;
	description = "The user running this application";
      };

    };

  config = lib.mkIf cfg.enable {   
    
    home.packages = with pkgs; [
      nicotine-plus
    ];
    
    xdg.configFile."nicotine/HomeManagerInit_config" = {
      text = lib.generators.toINI {} {
        server = {
          login = "NICOTINE_USER";
	  passw = "NICOTINE_PASS";
	};
	userinfo = {
	  userdesc = "lastfm: https://last.fm/user/polarfill :D";
	};
	interests = {
          likes = "[ \"lossless songs\" \"linux\" \"nixos\" \"foss\" ]";
	};
	ui = {
	  dark_mode = "True";
	};
	transfers = {
          shared = "[ \"/home/${cfg.current_user}/Music\" ]";
	  incompletedir = "/home/${cfg.current_user}/Music/nicotine_incomplete";
	  downloaddir = "/home/${cfg.current_user}/Music/nicotine_download";
	  uploaddir = "/home/${cfg.current_user}/Music/nicotine_received";
	};
      };
      onChange = ''
        # Theres a lot of options we don't set in the nicotine config, so we give it permission to write whatever's missing :D
        rm -f ${config.xdg.configHome}/nicotine/config
        cp ${config.xdg.configHome}/nicotine/HomeManagerInit_config ${config.xdg.configHome}/nicotine/config
        chmod u+w ${config.xdg.configHome}/nicotine/config
        sed -i "s/NICOTINE_USER/$(cat ~/.config/sops-nix/secrets/auths/slsk/user)/g" ${config.xdg.configHome}/nicotine/config
        sed -i "s/NICOTINE_PASS/$(cat ~/.config/sops-nix/secrets/auths/slsk/password)/g" ${config.xdg.configHome}/nicotine/config
      '';
    };
  }; 
} 
