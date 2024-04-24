{ config, lib, pkgs, ... }:

let
  cfg = config.nixosModules.default.os.pipewire;
in {
  options.nixosModules.default.os.pipewire = {
    enable = lib.options.mkEnableOption {
      default = false;
      type = lib.types.bool;
      description = "Enables funcional audio";
    };
  };

config = lib.mkIf cfg.enable {

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
	default.clock.quantum = 32;
	default.clock.min-quantum = 32;
	default.clock.max-quantum = 32;
      };
    extraConfig.pipewire-pulse."92-low-latency" = {
      context.modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
          pulse.min.req = "32/48000";
          pulse.default.req = "32/48000";
          pulse.max.req = "32/48000";
          pulse.min.quantum = "32/48000";
          pulse.max.quantum = "32/48000";
          }; 
	}
      ];
      stream.properties = {
        node.latency = "32/48000";
	resample.quality = 1;
      };
     };
    };
  };
};
}
