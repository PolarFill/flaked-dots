{ inputs, pkgs, lib, config, ... }:

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
      enable = true;
      uninstallUnmanaged = true;
      update.onActivation = true;
     # update.auto.enable = true;
      remotes = [
        { 
	  name = "flathub-beta"; 
	  location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
	}
	{
          name = "flathub";
	  location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
	}
      ];
   };
  }; 
}
