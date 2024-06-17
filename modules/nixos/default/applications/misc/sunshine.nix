{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.nixosModules.default.applications.misc.sunshine;
  in {
    options.nixosModules.default.applications.misc.sunshine = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.bool;
        description = "Setups sunshine, a foss impl of nvidia gamestream protocol!";
      };
      
      enableKeyboard = lib.options.mkOption {
        default = true;
	type = lib.types.bool;
	description = "Enables client control over host's keyboard";
      };

      enableMouse = lib.options.mkOption {
        default = true;
	type = lib.types.bool;
	description = "Enables client control over host's mouse";
      };

      captureMode = lib.options.mkOption {
        default = "nvfbc";
	type = lib.types.addCheck lib.types.str (x: builtins.elem x [ "nvfbc" "wlr" "kms" "x11" ]);
	description = "Sets the capture method. NVFBC requires a patched nvidia driver.";
      };

    };

  config = lib.mkIf cfg.enable {   

    environment.systemPackages = with pkgs; [
      (sunshine.override {
        cudaSupport = true;
        stdenv = pkgs.cudaPackages.backendStdenv;})
    ];
    
    services.sunshine = {
      enable = true;
      openFirewall = true;
      settings = {
        keyboard = "${lib.boolToString cfg.enableKeyboard}";
        mouse = "${lib.boolToString cfg.enableMouse}";
        min_log_level = "debug";
        key_rightalt_to_key_win = "enabled";
        upnp = "enabled"; 
      };
    };

    services.avahi = {
      enable = true;
      publish = {
        enable = true;
	userServices = true;
      };
    };

  };
}

