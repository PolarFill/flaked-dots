{ config, lib, ... }:

  let
    cfg = config.nixosModules.default.os.network.tor;
    
  in {
    options.nixosModules.default.os.network.tor = {

      enable = lib.options.mkEnableOption {
        default = false;
        type = lib.types.bool;
        description = "Enables tor :D";
      };

      enableSnowflake = lib.options.mkOption { 
	default = false;
	type = lib.types.bool;
	description = "Enables snowflake proxy to help others circuvent censorship";
      };

      torClient = {
	enable = lib.options.mkOption { 
	  # You can read more about slow and fast ports here https://nixos.wiki/wiki/Tor
	  default = false;
	  type = lib.types.bool;
	  description = "Exposes tor via sock5 (9050 for 'slow' ports, 9063 for 'fast' ports)";	
	};
	usePrivoxy = lib.options.mkOption { 
	  default = true;
	  type = lib.types.bool;
	  description = "Also exposes a privoxy http proxy to substitute the 'fast' ports for http";
	};
      };

      torRelay = with lib.types; {
	  enable = lib.options.mkEnableOption { default = false; };
	  relayType = lib.options.mkOption { default = "relay"; type = str; };
	  nickname = lib.options.mkOption { default = null; type = nullOr (addCheck str (x: builtins.isString x)); };
	  contactInfo = lib.options.mkOption { default = null; type = nullOr (addCheck str (x: builtins.isString x)); };
	  maxBandwidth = lib.options.mkOption { default = "100 MB"; type = str; };
	  bandwidthRate = lib.options.mkOption { default = "50 MB"; type = str; };
      };

    };

  config = lib.mkIf cfg.enable {
    
    services.tor = {
      enable = if (cfg.torClient.enable || cfg.torRelay.enable) then true else false;
      torsocks.enable = cfg.torClient.enable;
      client = {
	enable = cfg.torClient.enable;
      };
      relay = {
	enable = cfg.torRelay.enable;
	role = cfg.torRelay.relayType;
      };
      settings = lib.mkIf (cfg.torRelay.enable) {
	Nickname = cfg.torRelay.nickname;
	ContactInfo = cfg.torRelay.contactInfo;	
	ORPort = [443];
	ExitRelay = false;

	MaxAdvertisedBandwidth = cfg.torRelay.maxBandwidth;
	BandwithRate = cfg.torRelay.bandwidthRate;
	RelayBandwidthRate = cfg.torRelay.maxBandwidth;
	RelayBandwidthBurst = cfg.torRelay.bandwidthRate;

	CookieAuthentication = true;
	AvoidDiskWrites = 1;
	HardwareAccel = 1;
	SafeLogging = 1;
      };
    };

    services.snowflake-proxy = {
      enable = cfg.enableSnowflake;
      capacity = 10;
    };

    services.privoxy = lib.mkIf ( cfg.torClient.enable && cfg.torClient.usePrivoxy ) {
      # Avaible via port 8118
      enable = true;
      enableTor = true;
    };

  };
}
