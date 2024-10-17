{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.os.network.i2p;
  in {
    options.nixosModules.default.os.network.i2p = {

      enable = lib.options.mkEnableOption {
        default = false;
        type = lib.types.bool;
        description = "Enables i2p p2p anonymous network";
      };

      proxies = {
	http = lib.options.mkOption {
	  default = false;
	  type = lib.types.bool;
	  description = "Exposes i2p via a http proxy";
	};
	socks = lib.options.mkOption {
	  default = false;
	  type = lib.types.bool;
	  description = "Exposes i2p via a socks proxy";
	};

      };

    };

  config = lib.mkIf cfg.enable {

    services.i2pd = {
      enable = true;
      enableIPv6 = config.networking.enableIPv6;
      logLevel = "info";
      /*
      outTunnels = {
	socks-tunnel = lib.mkIf cfg.proxies.socks {
	  enable = true;
	  name = "socks-tunnel";
	  destination = "";
	};
      };
      */
      proto = {
	socksProxy.enable = cfg.proxies.socks;
	httpProxy.enable = cfg.proxies.http;
      };
    }; 

  };
}
