{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.system.network.wireless;
  in {

    options.nixosModules.default.system.network.wireless = {

      enable = lib.options.mkEnableOption {
	default = false;
	type = lib.types.bool;
	description = "Changes some ssh settings";
      };

    };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.networkmanager
    ];

    networking.networkmanager = {
      enable = true;
      ensureProfiles = {
      environmentFiles = [ config.sops.secrets."wifi/wifi-keys".path ];
	profiles = {
	  "ARK 2202 2.4G" = {
	    connection = {
	      id = "ARK 2202 2.4G";
	      interface-name = "wlp2s0f0u8";
	      type = "wifi";
	      uuid = "d5b0d156-d2b0-4a5e-9607-e38bd236a276";
	    };
	    ipv4 = {
	      method = "auto";
	    };
	    ipv6 = {
	      addr-gen-mode = "default";
	      method = "auto";
	    };
	    proxy = { };
	    wifi = {
	      mode = "infrastructure";
	      ssid = "ARK 2202 2.4G";
	    };
	    wifi-security = {
	      auth-alg = "open";
	      key-mgmt = "wpa-psk";
	      psk = "$HomeWifi1Pass";
	    };
	  };
	};
      };
    }; 

  };
}
