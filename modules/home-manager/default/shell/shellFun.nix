 {inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.shell.shellFun;
  in {
    options.homeModules.default.shell.shellFun = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables some cool things like fasfetch and cbonsai!";
      };
    };

  config = lib.mkIf cfg.enable {   
    home.packages = with pkgs; [ 
      fastfetch
      cbonsai
    ];
  };
}
