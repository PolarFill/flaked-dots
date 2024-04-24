{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.term.alacritty;
  in {
    options.homeModules.default.applications.term.alacritty = {
      
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables the alacritty terminal emulator!";
      };
      
      alacrittyTheme = lib.options.mkOption {
        default = "default";
	type = lib.types.str;
	description = "Sets alacritty theme";
      };

    };

  config = lib.mkIf cfg.enable {   
    home.packages = with pkgs; [ 
      alacritty
      tmux
      cozette
    ];

    programs.alacritty = {
      enable = true;
      settings = {
        
	import = lib.mkIf ( cfg.alacrittyTheme != "default" ) [ ./themes/${cfg.alacrittyTheme}.toml ];

        font = { size = 11; };
        font.normal = { family = "cozette"; style = "Regular"; };
        font.bold = { family = "cozette"; style = "Bold"; };
        font.italic = { family = "cozette"; style = "Italic"; };
        font.bold_italic = { family = "cozette"; style = "Bold Italic"; };

      };
    };

    programs.tmux = {
      clock24 = true;
      keyMode = "vi";
      mouse = true;
    };

  };
}
