{ config, lib, pkgs, ... }:

let
  cfg = config.nixosModules.default.hardware.nvidia;
in {
  options.nixosModules.default.hardware.nvidia = {
    enable = lib.options.mkEnableOption {
      default = false;
      type = lib.types.bool;
      description = "Enables nvidia drivers and kernel support";
    };
  };

config = lib.mkIf cfg.enable {
 # NVIDIA things lol

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  
  boot = {
    # kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
    initrd.kernelModules = [ "nvidia" "nvidia_uvm" "nvidia_drm" ];
   # extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
#    package = config.boot.kernelPackages.nvidiaPackages.beta;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.42.02";
      sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
      sha256_aarch64 = lib.fakeSha256;
      openSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
      settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
      persistencedSha256 = lib.fakeSha256;
};

};
};
}
