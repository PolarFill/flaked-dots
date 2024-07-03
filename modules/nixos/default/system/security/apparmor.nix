{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.system.security.apparmor;
  in {
    options.nixosModules.default.system.security.apparmor = {

      enable = lib.options.mkEnableOption {
        default = false;
        type = lib.types.bool;
        description = "Enables apparmor!";
      };

    };

  config = lib.mkIf cfg.enable {
 
    environment.systemPackages = with pkgs; [
      apparmor-utils
      apparmor-bin-utils
    ];

    security.apparmor = {
      enable = true;
      enableCache = true;
      killUnconfinedConfinables = true;
      packages = with pkgs; [
        apparmor-profiles
        roddhjav-apparmor-rules
      ];
    };

    services.dbus.apparmor = "enabled";

  };
}
