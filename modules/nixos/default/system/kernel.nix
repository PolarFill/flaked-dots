{ config, lib, ... }:

let
  cfg = config.nixosModules.default.system.kernel;
in {
  options.nixosModules.default.system.kernel = {
    enable = lib.options.mkEnableOption {
      default = false;
      type = lib.types.bool;
      description = "Changes some kernel settings";
    };
  };

config = lib.mkIf cfg.enable {

#  boot.kernelPackages = pkgs.linuxPackages_

};
}
