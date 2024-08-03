{ pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.misc.keepassxc;
  in {
    options.homeModules.default.applications.misc.keepassxc = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Foss password manager!";
      };
    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
      keepassxc
    ];

    xdg.configFile."keepassxc/hm_keepassxc.ini" = {
      text = lib.generators.toINI {} {
        General = {
	  BackupBeforeSave = true;
	  UseAtomicSaves = true;
	};
	GUI = {
	  ApplicationTheme = "dark";
	  ColorPasswords = true;
	  MonospaceNotes = true;
	};
	Security = {
	  IconDownloadFallback = true;
	};
      };
      onChange = ''
        rm -f ${config.xdg.configHome}/keepassxc/keepassxc.ini
        cp ${config.xdg.configHome}/keepassxc/hm_keepassxc.ini ${config.xdg.configHome}/keepassxc/keepassxc.ini
        chmod u+w ${config.xdg.configHome}/keepassxc/keepassxc.ini
      '';
    };

    home.file = {
      pt_wordlist = {
	source = ./wordlists/diceware.wordlist.pt.txt;
	target = ".config/keepassxc/wordlists/";
      };
    };

  };
}

