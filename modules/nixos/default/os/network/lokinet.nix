{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.os.network.lokinet;
  in {
    options.nixosModules.default.os.network.lokinet = {
      enable = lib.options.mkEnableOption {
        default = false;
        type = lib.types.bool;
        description = "Enables lokinet anonymizing network";
      };
    };

  config = lib.mkIf cfg.enable {
    
    services.lokinet = {
      enable = true;
      #useLocally = true;
      settings = {
	dns.upstream = [ "9.9.9.9" ];
	network.exit-node = [ "exit.loki" ];
      };
    };

  };
}
