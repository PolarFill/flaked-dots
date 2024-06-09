{ config, lib, pkgs, ... }:

let
  cfg = config.nixosModules.default.hardware.nvidia.proprietary;
in {
  options.nixosModules.default.hardware.nvidia.proprietary = {

    enable = lib.options.mkEnableOption {
      default = false;
      type = lib.types.bool;
      description = "Enables nvidia drivers and kernel support";
    };

  };

  config = lib.mkIf cfg.enable {
   # NVIDIA things lol

    environment.systemPackages = [
      pkgs.mesa
    ];

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    boot = {
      initrd.kernelModules = [ "nvidia" "nvidia_uvm" "nvidia_drm" ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
