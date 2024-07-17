{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.web.qbittorrent;
  in {
    options.homeModules.default.applications.web.qbittorrent = {
      
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables the qbittorent torrent client!";
      };
      
      theme = lib.options.mkOption {
        default = null; 
	type = lib.types.nullOr lib.types.str;
	description = "Sets qbittorrent theme";
      };

    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [ 
      qbittorrent
    ];

    xdg.configFile."qBittorrent/hm_qBittorrent.conf" = {
      text = lib.generators.toINI {} {
        LegalNotice = {
	  Accepted = "true";
	};
	Preferences = {
	  "General\\UseCustomUITheme" = if cfg.theme != null then "true" else "false";
	  "General\\CustomUIThemePath" = if cfg.theme != null then "${config.xdg.configHome}/qBittorrent/${cfg.theme}.qbtheme" else ""; 
	};
      };
      onChange = ''
        rm -f ${config.xdg.configHome}/qBittorrent/qBittorrent.conf
        cp ${config.xdg.configHome}/qBittorrent/hm_qBittorrent.conf ${config.xdg.configHome}/qBittorrent/qBittorrent.conf
        chmod u+w ${config.xdg.configHome}/qBittorrent/qBittorrent.conf
      '';
    };

    home.file."${config.xdg.configHome}/qBittorrent/${cfg.theme}.qbtheme" = lib.mkIf ( cfg.theme != null ) {
      source = ./themes/${cfg.theme}.qbtheme;
    };

  };
}
