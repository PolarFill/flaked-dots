{ config, lib, ... }:

let
  cfg = config.nixosModules.default.os.greetd;
in {
  options.nixosModules.default.os.greetd = {
    enable = lib.options.mkEnableOption {
      default = false;
      type = lib.types.bool;
      description = "Setup greetd for login";
    };
  };

config = lib.mkIf cfg.enable {

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet";
	user = "greeter";
      };
    };
  };

};
}
