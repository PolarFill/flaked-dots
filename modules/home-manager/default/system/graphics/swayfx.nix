{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.system.graphics.swayfx;
  in {
    options.homeModules.default.system.graphics.swayfx = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables the swayfx wm!";
      };
    };

  config = lib.mkIf cfg.enable {   

    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
      extraOptions = [ "--unsupported-gpu" ];
      checkConfig = false;
      wrapperFeatures = { 
        gtk.enable = true; 
	base.enable = true; 
      };
      config = {
        
	modifier = "Mod4";

        keybindings = 
	  let
	    mainMod = config.wayland.windowManager.sway.config.modifier;
	  in lib.mkOptionDefault {
            "${mainMod}+Enter" = "exec alacritty";
	  };
      };
    };


    home.sessionVariables = {
      _JAVA_AWT_WM_NONREPARENTING = "1";
      _XCURSOR_SIZE = "24";
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
  };
}

