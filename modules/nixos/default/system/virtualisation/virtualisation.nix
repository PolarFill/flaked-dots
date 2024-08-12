{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.system.virtualisation.virtualisation;
  in {
    options.nixosModules.default.system.virtualisation.virtualisation = {

      enable = lib.options.mkEnableOption {
        default = false;
        type = lib.types.bool;
        description = "Sets up some virt stuff";
      };

      nvidia = lib.options.mkOption {
	default = false;
	type = lib.types.bool;
	description = "Enables gpu-accelerated containers for nvidia";
      };
      
    };

  config = lib.mkIf cfg.enable {

    hardware.nvidia-container-toolkit.enable = cfg.nvidia;

    virtualisation = {
      spiceUSBRedirection.enable = true;
      lxd.enable = true;
      podman = {
	defaultNetwork.settings = {
	  dns_enabled = true;
	};
	dockerCompat = true;
	dockerSocket.enable = true;
	enable = true;
      };
    };

  };
}
