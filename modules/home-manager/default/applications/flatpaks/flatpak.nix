{ lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.flatpaks.flatpak;
  in {
    options.homeModules.default.applications.flatpaks.flatpak = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Sets up flatpak support!";
      };

    };

  config = lib.mkIf cfg.enable {   

    services.flatpak = {
      enableModule = true;
      remotes = { 
	flathub-beta = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        flathub = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
   };
  }; 
}
