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

  };
}

