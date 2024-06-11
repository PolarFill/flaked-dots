{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.term.dev.python;
  in {
    options.homeModules.default.applications.term.dev.python = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Setups python system-wide!";
      };
    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
      python313
    ];

  };
}
