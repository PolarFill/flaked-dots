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
    kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
    initrd.kernelModules = [ "nvidia" "nvidia_uvm" "nvidia_drm" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
#    prime = {
#      sync.enable = true;
#      intelBusId = "PCI:0:2:0";
#      nvidiaBusId = "PCI:1:0:0";
#    };
#    package = 
#      let
#        rcu_patch = pkgs.fetchpatch {
#          url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
#          hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
#        };
#      in config.boot.kernelPackages.nvidiaPackages.mkDriver {
#        version = "535.154.05";
#        sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
#        sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
#        openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
#        settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
#        persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
#
#        patches = [ rcu_patch ];
 # };
};
};
}
