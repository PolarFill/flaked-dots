# Addendum: Disabling config check is needed for swayfx to work on nix. See: https://github.com/nix-community/home-manager/issues/5379

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

    home.packages = with pkgs; [
      autotiling
      sway-contrib.grimshot
    ];

    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
      extraOptions = [ "--unsupported-gpu" ];
      checkConfig = false; 
      systemd.enable = true;
      wrapperFeatures = { 
        gtk.enable = true; 
	base.enable = true; 
      };
    };

    wayland.windowManager.sway.config = {
      modifier = "Mod4";
      terminal = "alacritty";
      focus.mouseWarping = false;

      keybindings = let
	  mainMod = config.wayland.windowManager.sway.config.modifier;
	  mainModS = "${mainMod}+Shift";
	  mainModC = "${mainMod}+Control";
	  mainModA = "${mainMod}+Alt";
	in lib.mkOptionDefault {
          
	  # Main actions
	  "${mainMod}+Enter" = "exec alacritty";
          "${mainMod}+Q" = ""

          # Audio control
	  "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+";
	  "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";

	  # Screenshot
	  "Print" = "exec grimshot copysave output $HOME/screenshots/full/$(date +'%F-%T.png')";
	  "${mainMod}+Print" = "exec grimshot copysave area $HOME/screenshots/area/$(date +'%F-%T.png')";
	  "${mainModS}+Print" = "exec grimshot copysave active $HOME/screenshots/active/$(date +'%F-%T.png')";

          
	  "${mainMod}"
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
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}

