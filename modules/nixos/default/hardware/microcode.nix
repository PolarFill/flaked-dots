# While microcodes are really important and should be enabled,
# i'm following the minimalist principle here and putting disabled by default
# besides, theyre proprietary, so some folks may not like it

{ config, lib, pkgs, ... }:

let
  cfg = config.nixosModules.default.hardware.microcode;
in {
  options.nixosModules.default.hardware.microcode = {

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
    
    hardware.cpu.intel.updateMicrocode = lib.mkIf ( cfg.cpu == "intel" ) true;
    hardware.cpu.amd.updateMicrocode = lib.mkIf ( cfg.cpu == "amd" ) true;

  };
}
