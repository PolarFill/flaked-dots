{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.misc.libreoffice;
  in {
    options.homeModules.default.applications.misc.libreoffice = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enabled libreoffice suite!";
      };
    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
      libreoffice-qt
      hunspell
      hunspellDicts.pt_BR
    ];
  };
}

# yeah thats it lol
