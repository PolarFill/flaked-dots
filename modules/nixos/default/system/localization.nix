{ config, lib, ... }:

  let
    cfg = config.nixosModules.default.system.localization;
  in {
    options.nixosModules.default.system.localization = {

      enable = lib.options.mkEnableOption {
        default = false;
        type = lib.types.bool;
        description = "Sets up locale!";
      };

      defaultLocale = lib.options.mkOption {
        default = "en_US";
	type = lib.types.str;
	description = "Sets the default language!";
      };

      extraLocale = lib.options.mkOption {
        default = "en_US";
	type = lib.types.str;
	description = "Sets other locale like time and currency format";
      };

      timezone = lib.options.mkOption {
        default = "America/Sao_Paulo";
	type = lib.types.str;
	description = "Sets the default timezone";
      };

      keyMap = lib.options.mkOption {
        default = "br-abnt2";
	type = lib.types.str;
	description = "Sets the default keymap";
      };

    };

  config = lib.mkIf cfg.enable {

    time.timeZone = cfg.timezone;

    i18n.defaultLocale = "${cfg.defaultLocale}.UTF-8";
    i18n.extraLocaleSettings = {
      LANGUAGE = "${cfg.defaultLocale}.UTF-8";
      LC_ADDRESS = "${cfg.extraLocale}.UTF-8";
      LC_IDENTIFICATION = "${cfg.extraLocale}.UTF-8";
      LC_MEASUREMENT = "${cfg.extraLocale}.UTF-8";
      LC_MONETARY = "${cfg.extraLocale}.UTF-8";
      LC_NAME = "${cfg.extraLocale}.UTF-8";
      LC_NUMERIC = "${cfg.extraLocale}.UTF-8";
      LC_PAPER = "${cfg.extraLocale}.UTF-8";
      LC_TELEPHONE = "${cfg.extraLocale}.UTF-8";
      LC_TIME = "${cfg.extraLocale}.UTF-8";
    };

    console.keyMap = cfg.keyMap;
  };
}
