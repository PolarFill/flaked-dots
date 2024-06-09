{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.rice.swww;
  in {
    options.homeModules.default.applications.rice.swww = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Sets up swww!";
      };

      wallpaper = lib.options.mkOption {
        default = [ ./default.png ];
	type = lib.types.either lib.types.path ( lib.types.listOf lib.types.path ); 
	description = "A custom path for the wallpaper";
      };

    };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      swww 
    ];

    systemd.user.services.swww = {
    
      Unit = {
        Description = "Simple wallpaper service for wlroots compositors";
	Documentation = [ "man:swww(1)" ];
	Requires = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        Type = "exec";
	RemainAfterExit = "yes";
	ExecStart = "${pkgs.swww}/bin/swww-daemon --no-cache";
	ExecStartPost =
	  if builtins.typeOf cfg.wallpaper != ( lib.types.listOf lib.types.path )
	  then "${pkgs.writeShellScript "swww-init-script" ''${pkgs.swww}/bin/swww img ${cfg.wallpaper}''}"
	  else "${pkgs.writeShellScript "swww-init-script" ''
	    ${ builtins.map cfg.wallpaper (x: "${pkgs.swww}/bin/swww img" + x + "--transition-fps 144 --transition-type simple") }
	  ''}";
	ExecStop = "${pkgs.swww}/bin/swww kill";
      };

    };

  }; 
}


	   # ${ lib.lists.forEach cfg.wallpaper (x: "${pkgs.swww}/bin/swww img ${x}") }
