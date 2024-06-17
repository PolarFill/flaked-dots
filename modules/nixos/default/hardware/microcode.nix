# While microcodes are really important and should be enabled,
# i'm following the minimalist principle here and putting disabled by default
# besides, theyre proprietary, so some folks may not like it

{ config, lib, pkgs, ... }:

let
  cfg = config.nixosModules.default.hardware.cpuMicrocode;
in {
  options.nixosModules.default.hardware.cpuMicrocode = {

    enable = lib.options.mkEnableOption {
      default = false;
      type = lib.types.bool;
      description = "Enables the cpu microcode";
    };

    cpu = lib.options.mkOption {
      default = null;
      type = lib.types.nullOr (lib.types.addCheck lib.types.str (x: builtins.elem x [ "intel" "amd" ]));
      description = "Sets the desired cpu. Obrigatory";

    };

  };

  config = lib.mkIf cfg.enable {

    if cfg.cpu == "intel"
    then hardware.cpu.intel.updateMicrocode = true
    else {
      if cfg.cpu == "amd"
      then hardware.cpu.amd.updateMicrocode = true
      else builtins.trace "No cpu was selected for hardware.cpuMicrocode!" hardware.cpu.amd.updateMicrocode = false;
    };

  };
}
