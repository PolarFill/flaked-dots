{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.nixosModules.default.applications.steam;
  in {
    options.nixosModules.default.applications.steam = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables steam";
      };
    };

  config = lib.mkIf cfg.enable {   

    environment.systemPackages = [
      "gamemode"
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
	pkgs.luxtorpeda
      ];
    };

    programs.gamemode.settings = {
      enable = true;
      enableRenice = true;

      settings = {
        custom = {
          start = "echo \"Running with gamemode!\"";
	};
	general = {
          desiredgov = "performance";
	  igpu_desiredgov = "powersave";
	  softrealtime = "auto";
	  renice = 10
	}
      };
    };
  };
}

