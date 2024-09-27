{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.nixosModules.default.applications.misc.ns-usbloader;
  in {
    options.nixosModules.default.applications.misc.ns-usbloader = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.bool;
        description = "Installs ns-usbloader to install nsp's via usb on awoo :DDDDD";
      };
      
    };

  config = lib.mkIf cfg.enable {   

  # Yea thats the whole ass module

  programs.ns-usbloader.enable = true;

  };
}

