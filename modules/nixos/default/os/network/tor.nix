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

      enableTorClient = lib.options.mkOption { 
	default = false;
	type = lib.types.bool;
	description = "Enables snowflake proxy to help others circuvent censorship";
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
      enable = if (cfg.enableTorClient || cfg.torRelay.enable) then true else false;
      torsocks.enable = true;
      client = {
	enable = cfg.enableTorClient;
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

  };
}
