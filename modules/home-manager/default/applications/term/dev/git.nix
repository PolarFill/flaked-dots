 {inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.term.dev.git;
  in {
    options.homeModules.default.applications.term.dev.git = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables and configures git!";
      };
    };

  config = lib.mkIf cfg.enable {   

    programs.git = {
      
      enable = true;
      lfs.enable = true;

      userName = "polarfill";
      #userEmail = "";
      
      aliases = {
	push-main = "push origin main";
	s = "status";
	commit = "commit -m";
      };

      extraConfig = {
        init = { defaultBranch = "main"; };
	push = { autoSetupRemote = true; };
      };
    };
  };
}
