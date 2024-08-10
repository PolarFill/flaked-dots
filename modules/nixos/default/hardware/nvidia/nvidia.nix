# withUnlocks option requires you to insert "inputs.nvidia-patch.overlays.default" in nixpkgs.overlays
# read https://github.com/icewind1991/nvidia-patch-nixos for more info :D
# off by default for easier reproduction (no need to insert overlay by default)

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

    withUnlocks = lib.options.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enables NVENC and NVFBC patching";
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
      initrd.kernelModules = [ "nvidia" "nvidia_uvm" "nvidia_drm" ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = 
        if cfg.withUnlocks == true
	then pkgs.nvidia-patch.patch-nvenc (pkgs.nvidia-patch.patch-fbc config.boot.kernelPackages.nvidiaPackages.beta)
	else config.boot.kernelPackages.nvidiaPackages.beta; 
    };
  };
}
