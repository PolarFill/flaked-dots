# Fonts with hm wont work, so theyre actually defined at system-level
# In other words, dont bother using this lol, its only here if its someday needed

{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.system.misc.fonts;
  in {
    options.homeModules.default.system.misc.fonts = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Sets the default system fonts for our current user!";
      };
    };

  config = lib.mkIf cfg.enable {   

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      noto-fonts
    ];

  };
}
