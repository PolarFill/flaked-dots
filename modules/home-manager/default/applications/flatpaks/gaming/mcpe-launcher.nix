# To be able to use renice features, the current user must be part of the 'gamemode' group
# It's impossible to add a user to a group in user-scope for obvious reasons, so it needs to be done
# manually or in the configuration.nix file (aka system-scope definitions)

{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.flatpaks.gaming.mcpe-launcher;
  in {
    options.homeModules.default.applications.flatpaks.gaming.mcpe-launcher = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables mcpe-launcher flatpak to play minecraft bedrock under linux!";
      };

    };

  config = lib.mkIf cfg.enable {   
    
    services.flatpak.packages = [
      "flathub:app/io.mrarm.mcpelauncher/x86_64/master" 
    ];

   # sops.templates.".var/app/io.mrarm.mcpelauncher/config/Minecraft Linux Launcher/Minecraft Linux Launcher UI.conf".content = '' 
   #   
   # '';

  }; 
}
