{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.system.kernel;
  in {
    options.nixosModules.default.system.kernel = {

      enable = lib.options.mkEnableOption {
	default = false;
	type = lib.types.bool;
	description = "Changes some kernel settings";
      };

      kernel = lib.options.mkOption {
	default = "latest";
	type = lib.types.str;
	description = "Changes the current kernel";
      };
      

    };

  config = lib.mkIf cfg.enable {

    boot.kernelPackages = pkgs."linuxPackages_${cfg.kernel}";

    boot.extraModulePackages = with config.boot.kernelPackages; [
      rtl88xxau-aircrack
    ];

  };
}
