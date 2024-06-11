# The override used for btop package was blatantly copied from this nixpkgs issue:
# https://github.com/NixOS/nixpkgs/issues/297487
# thx Slime90!

{inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.term.utils.btop;
  in {
    options.homeModules.default.applications.term.utils.btop = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables and configures btop!";
      };

      theme = lib.options.mkOption {
        default = null;
	type = lib.types.nullOr lib.types.str;
	description = "Sets the application theme";
      };

    };

  config = lib.mkIf cfg.enable {   

    programs.btop = {
      
      enable = true;
      
      package = pkgs.btop.overrideAttrs (oldAttrs: rec {
        rocmSupport = true;
        cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
          "-DBTOP_GPU=ON"
        ];
      });

      settings = {
        color_theme = "${if cfg.theme != null then cfg.theme else ""}";
	vim_keys = true;
	proc_tree = true;
	proc_sorting = "pid";
	disk_filter = "";
      };
    
    };

    home.file = lib.mkIf ( cfg.theme != null ) {
      btopTheme = {
        target = ".config/btop/themes/${cfg.theme}.theme";
	source = ./themes/${cfg.theme}.theme; 
      };
    };

  };
}
