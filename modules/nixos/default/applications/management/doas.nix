{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.nixosModules.default.applications.management.doas;
  in {
    options.nixosModules.default.applications.management.doas = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables doas!";
      };

      users = lib.options.mkOption {
        default = null;
	type = lib.types.nullOr ( lib.types.listOf lib.types.str );
	description = "Current users for which extraRules will apply (keepEnv and persist)";
      };

    };

  config = lib.mkIf cfg.enable {   

    # We need to disable sudo first
    security.sudo.enable = false;
    
    security.doas = {
      enable = true;
      extraRules = [{
        users = cfg.users;
        keepEnv = true;
        persist = true;
      }];
    };

 };
}

