# Since making an option to use nouveau instead of the proprietary drivers on nvidia.nix changes almost the entire config anyway, i decided to separate them.

# Keep in mind this config isn't compatible with the nvidia.nix one (nvidia.proprietary), and vice-versa.

{ config, lib, pkgs, ... }:

let
  cfg = config.nixosModules.default.hardware.nvidia.nouveau;
in {
  options.nixosModules.default.hardware.nvidia.nouveau = {

    enable = lib.options.mkEnableOption {
      default = false;
      type = lib.types.bool;
      description = "Enables nouveau nvidia driver.";
    };

  };

  config = lib.mkIf cfg.enable {
   # NVIDIA things lol

    environment.systemPackages = [
      pkgs.mesa
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    boot = {
      kernelParams = [ "nouveau.config=NvGspRm=1" ];
    };

    services.xserver.videoDrivers = [ "nouveau" ];

  };
}
