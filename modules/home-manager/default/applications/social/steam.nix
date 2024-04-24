{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.social.steam;
  in {
    options.homeModules.default..applications.social.steam = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Sets the default system fonts for our current user!";
      };
    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
      steam
      gamescope
    ];
  };
}
