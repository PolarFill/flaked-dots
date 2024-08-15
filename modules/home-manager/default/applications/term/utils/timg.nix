{inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.term.utils.timg;
  in {
    options.homeModules.default.applications.term.utils.timg = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables and configures timg image viewer!";
      };

    };

  config = lib.mkIf cfg.enable {   

    home.packages = [
      pkgs.timg
    ];

    home.shellAliases = {
      timg = "timg -ps --upscale --grid=5 --title --auto-crop";
      timg-nogrid = "timg -ps --upscale --title --auto-crop";
    };

  };
}
