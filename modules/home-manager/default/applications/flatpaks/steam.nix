# To be able to use renice features, the current user must be part of the 'gamemode' group
# It's impossible to add a user to a group in user-scope for obvious reasons, so it needs to be done
# manually or in the configuration.nix file (aka system-scope definitions)

{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.flatpaks.steam;
  in {
    options.homeModules.default.applications.flatpaks.steam = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables steam flatpak!";
      };

    };

  config = lib.mkIf cfg.enable {   
    
    home.packages = [
      pkgs.gamemode
    ];

    services.flatpak.packages = [
      { appId = "com.valvesoftware.Steam"; origin = "flathub-beta"; }
    ];

    xdg.configFile."gamemode.ini".text = lib.generators.toINI {} {
      general = {
        desiredgov = "performance";
        softrealtime = "auto";
        renice = "10";
	ioprio = "0";
      };
      cpu = {
        pin_cores = "yes";
      };
      custom = {
        start = "nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=1'";
	end = "nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=0'";
      };
    };

  }; 
}
