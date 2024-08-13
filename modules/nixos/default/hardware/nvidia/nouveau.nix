# Since making an option to use nouveau instead of the proprietary drivers on nvidia.nix changes almost the entire config anyway, i decided to separate them.

# Keep in mind this config isn't compatible with the nvidia.nix one (nvidia.proprietary), and vice-versa.

{ inputs, config, lib, pkgs, ... }:

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

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ 
	xorg.xf86videonv
	xorg.xf86videonouveau      
	vaapiVdpau 
	vulkan-tools
	vulkan-validation-layers
      ]; 
      package = pkgs.mesa.drivers;
      /*
      package = (pkgs.mesa.override {
	galliumDrivers = [
	  "nouveau"
          "swrast"
          "zink" 
        ];
	vulkanDrivers = [
	  "swrast"
          "nouveau"
        ];
      }).drivers;
      */
    };

   # chaotic.mesa-git = {
   #   enable = true;
   #  # extraPackages = [ pkgs.vaapiIntel pkgs.amdvlk ];
   # };

    boot = {
      kernelParams = [ "nouveau.config=NvGspRm=1" "nouveau.debug=info,VBIOS=info,gsp=debug" ];
      blacklistedKernelModules = [ "nvidia" "nvidia_uvm" ];
      kernelModules = [ "nouveau" ];
    };

    hardware.nvidia.modesetting.enable = false;

    services.xserver.videoDrivers = [ "modesetting" "nouveau" ];

  };
}
