# While the hyprcursor format has advantages over xcursor, it ONLY WORKS on hyprland.
# Keep that in mind before wasting your time lol

# Since hyprcursor doesn't have nixos/hm options, we just do everything manually
# Here, we configure hyprcursor, although not all applications work with it (gtk doesnt support it) 
# so, we define gtk (xcursor) cursor themes at system/gtk.nix

{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.system.graphics.hyprcursor;
  in {
    options.homeModules.default.system.graphics.hyprcursor = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables hyprcursor! (xcursors but better)";
      };
    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
      hyprcursor
    ];

    home.file = {
      rose_pine_theme = { source = ./themes/rose-pine-dark; target = ".local/share/icons/rose-pine-dark"; };
    };

    home.sessionVariables = { HYPRCURSOR_THEME = "rose-pine-dark"; };

  };
}
