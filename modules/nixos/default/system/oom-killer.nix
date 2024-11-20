{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.system.oom-killer;
  in {
    options.nixosModules.default.system.oom-killer = {

      enable = lib.options.mkEnableOption {
	default = false;
	type = lib.types.bool;
	description = "Enables some oom-killer impl";
      };

      implementation = lib.options.mkOption {
	default = "earlyoom";
	type = lib.types.addCheck lib.types.str (x: builtins.elem x [ "earlyoom" ]);
	description = "Selects which oom killer will be used";
      };

      ram = {
	 sigterm_at = lib.options.mkOption {
	  default = 5;
	  type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 100);
	  description = ''Percentage of the minimum free ram thats always required to be avaible.
			  If the avaible swap falls bellow this threshold, the oom killer will kick in
			  and SIGTERM the process thats using the most ram'';
	 };

	sigkill_at = lib.options.mkOption {
	  default = 3;
	  type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 100);
	  description = ''Same logic as \"sigterm_at\", but if the specified value is reached
			  it sends a SIGKILL instead'';
	};
      };

      swap = {
	 sigterm_at = lib.options.mkOption {
	  default = 5;
	  type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 100);
	  description = ''Percentage of the minimum free swap thats always required to be avaible.
			  If the avaible swap memory falls bellow this threshold, the oom killer will kick in
			  and SIGTERM the process thats using the most ram'';
	 };

	sigkill_at = lib.options.mkOption {
	  default = 3;
	  type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 100);
	  description = ''Same logic as \"sigterm_at\", but if the specified value is reached
			  it sends a SIGKILL instead'';
	};
      };

      prefs = {
	prefer = lib.options.mkOption {
	  default = null;
	  type = lib.types.nullOr lib.types.str;
	  description = ''Takes a regex, and makes processes that matches it more likely to be killed / terminated when needed.
			  Regex is matched based on the process name (/proc/pid/comm)'';
	};

	ignore = lib.options.mkOption {
	  default = null;
	  type = lib.types.nullOr lib.types.str;
	  description = ''Takes a regex, and makes processes that matches it immune to the killer.
			  Regex is matched based on the process name (/proc/pid/comm)'';
	};

	avoid = lib.options.mkOption {
	  default = null;
	  type = lib.types.nullOr lib.types.str;
	  description = ''Takes a regex, and makes processes that matches it less likely to be killed / terminated when needed.
			  Regex is matched based on the process name (/proc/pid/comm)'';
	};
      };

    };

  config = lib.mkIf cfg.enable {

    services.earlyoom = lib.mkIf ( cfg.implementation == "earlyoom" ) {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = cfg.ram.sigterm_at;
      freeMemKillThreshold = cfg.ram.sigkill_at;
      freeSwapThreshold = cfg.swap.sigterm_at;
      freeSwapKillThreshold = cfg.swap.sigkill_at;
      extraArgs = [
	"${ if cfg.prefs.prefer != null then "--prefer '${cfg.prefs.prefer}'" else "" }"
	"${ if cfg.prefs.avoid != null then "--avoid '${cfg.prefs.avoid}'" else "" }"
	"${ if cfg.prefs.ignore != null then "--ignore '${cfg.prefs.ignore}'" else "" }"
      ];
    };

    # This functions just as the "-p" flag functions for earlyoom
    # but since we use systemd we need to set its niceness in the 
    # service definition
    systemd.services.earlyoom = lib.mkIf ( cfg.implementation == "earlyoom" ) {
      serviceConfig = {
	OOMScoreAdjust = -100;
        Nice = -20;
      };
    };

  };
}
