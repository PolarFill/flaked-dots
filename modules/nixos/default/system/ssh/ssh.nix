{ config, lib, ... }:

  let
    cfg = config.nixosModules.default.system.ssh;
  in {

    options.nixosModules.default.system.ssh = {
      enable = lib.options.mkEnableOption {
	default = false;
	type = lib.types.bool;
	description = "Changes some ssh settings";
      };

      users = lib.options.mkOption {
	default = null;
	type = lib.types.nullOr (lib.types.listOf lib.types.str);
	description = "Sets the allowed users to login as remotelly";
      };

      secrets = lib.options.mkOption {
	default = false;
	type = lib.types.bool;
	description = "Allows secret usage";
      };
    	 
    };

  config = lib.mkIf cfg.enable {

    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
	PasswordAuthentication = false;
	AllowUsers = cfg.users;
	UseDns = true;
	PrintMotd = true;	
      };
    }; 

    programs.ssh = {
      startAgent = true;
      knownHostsFiles = [
	./known_hosts/sakisaki
	./known_hosts/github
      ];

      extraConfig = lib.mkIf ( cfg.secrets )
      ''
	  Host * 
	    IdentityFile ${config.sops.secrets."ssh-keys/private".path}
      '';
    };

    systemd.services.sshd.environment = {
      # XZ backdoor kill switch
      "yolAbejyiejuvnup" = "Evjtgvsh5okmkAvj";
    };

  };
}
