{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.system.graphics.hyprland;
  in {
    options.homeModules.default.system.graphics.hyprland = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables the hyprland wm!";
      };
    };

  config = lib.mkIf cfg.enable {   

    home.packages = [
      pkgs.gammastep # Needed for submap prettiness
      pkgs.swww

#      inputs.hyprlang.packages.${pkgs.system}.hyprlang

      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      inputs.hyprland-contrib.packages.${pkgs.system}.try_swap_workspace
      inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad
    ];

    # Config too big for me to move it to nix rn

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      extraConfig = builtins.readFile ./hypr/hyprland.conf;
      plugins = [
#        inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
#	inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
#	inputs.hyprland-virtual-desktops.packages.${pkgs.system}.virtual-desktops
      ];
    };

    home.file = {
      hyprland_sources = { source = ./hypr/sources; target = ".config/hypr/sources"; recursive = true; };
      hyprland_themes = { source = ./hypr/themes; target = ".config/hypr/themes"; recursive = true;  };
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
    #  XDG_CURRENT_DESKTOP = "hyprland";
    };
  };
}

