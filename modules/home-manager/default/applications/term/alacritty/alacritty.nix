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

      withSixel = lib.options.mkOption {
        default = false;
	type = lib.types.bool;
	description = "If true, ayosec's fork with sixel support will be used";
      };

    };

  config = lib.mkIf cfg.enable {   
    home.packages = with pkgs; [ 
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
      package =
        if cfg.withSixel == false
	then pkgs.alacritty
	else pkgs.alacritty.overrideAttrs (oldAttrs: rec {
          src = pkgs.fetchFromGitHub {
            owner = "ayosec";
            repo = "alacritty";
            rev = "e0d84e48e1a9705219a1a3074e087d3f015c4144";
            hash = "sha256-yajypRvpdy6Tjm5pBaEjOq0ykulEZtujklTzYrBoIFQ=";
          };
	  cargoDeps = oldAttrs.cargoDeps.overrideAttrs (lib.const {
            inherit src;
	    outputHash = "sha256-F9NiVbTIVOWUXnHtIUvxlZ5zvGtgz/AAyAhyS4w9f9I=";
	  });
	});
    };

    programs.tmux = {
      clock24 = true;
      keyMode = "vi";
      mouse = true;
    };

  };
}
