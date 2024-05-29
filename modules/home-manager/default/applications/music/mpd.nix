{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.music.mpd;
  in {
    options.homeModules.default.applications.music.mpd = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Sets up mpd!";
      };

      scrobbler_type = lib.options.mkOption {
        default = null;
	type = lib.types.nullOr lib.types.str;
	description = "Chooses scrobbler backend. Yams doesnt require user/pass, but wont work out of the box, while others require";
      };

    };

  config = lib.mkIf cfg.enable {   

    home.packages =
      if ( cfg.scrobbler_type == "yams" )
      then [ pkgs.yams ]
      else [ pkgs.mpdscribble ];
   
    services.mpd = {
      
      enable = true;

      extraArgs = [ "--verbose" ];
      musicDirectory = "~/Music";

      network.startWhenNeeded = true;
      network.listenAddress = "127.0.0.1";
      
      extraConfig = " auto_update      \"yes\" ";
    };

    systemd.user.services.mpdscribble = lib.mkIf ( cfg.scrobbler_type == "mpdscribble" ) {
      
      Unit = {
        Description = "mpdscribble, a scrobbler for MPD, systemd service!";
        Documentation = [ "man:mpdscribble(1)" ];
        After = [ "mpd.service" ];
        RequiresMountsFor = [ "/var/lib/mpd" ];
      };

      Install = {
        WantedBy = [ "multi-user.target" ];
      };

      Service = {
        Environment = "PATH=/run/current-system/sw/bin";
        ExecStart = "${pkgs.mpdscribble}/bin/mpdscribble";
	ExecStartPre = "${pkgs.writeShellScript "mpdscribble-init-config" '' 
	  /run/current-system/sw/bin/mkdir -p ~/.mpdscribble
	  /run/current-system/sw/bin/ln -s ${config.sops.secrets.conf_template.path} ~/.mpdscribble/mpdscribble.conf -f
	''}";
      };
    }; 
  };
}
