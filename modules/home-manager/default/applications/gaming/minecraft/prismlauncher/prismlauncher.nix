{  pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.gaming.minecraft.prismlauncher;
    config_path = ".local/share/PrismLauncher/instances/fabric-client-1.21/.minecraft/config";
    instance_path = ".local/share/PrismLauncher/instances/fabric-client-1.21/.minecraft/config";
  in {
    options.homeModules.default.applications.gaming.minecraft.prismlauncher = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "minceraft";
      };

      instances = lib.options.mkOption {
	default = [];
	type = lib.types.listOf lib.types.str;
	description = "Instances that will be activated";
      };

    };

  config = lib.mkIf cfg.enable ( lib.mkMerge [ 

    {   
      home.packages = with pkgs; [
	prismlauncher
      ];

      home.file.".local/share/PrismLauncher/tmp_prismlauncher.cfg" = {
	text = lib.generators.toINI {} {
	  General = {
	    # Setup-related settings
	    ApplicationTheme = "dark";
	    BackgroundCat = "kitteh";
	    IconTheme = "pe_colored";
	    Language = "en_US";
	    MinMemAlloc = "512";
	    MaxMemAlloc = "8192";
	    # Performance
	    EnableFeralGamemode = "true";
	    # Compatibility
	    UseNativeGLFW = "true";
	    UseNativeOpenAL = "true";
	    # Others
	    DownloadsDirWatchRecursive = true;
	  };
	};
	onChange = ''
	  rm -f ${config.home.homeDirectory}/.local/share/PrismLauncher/prismlauncher.cfg
	  cp ${config.home.homeDirectory}/.local/share/PrismLauncher/tmp_prismlauncher.cfg ${config.home.homeDirectory}/.local/share/PrismLauncher/prismlauncher.cfg
	  chmod u+w ${config.home.homeDirectory}/.local/share/PrismLauncher/prismlauncher.cfg
	'';
      };
    }

    ( lib.mkIf ( builtins.elem "fabric-client-1.21" cfg.instances ) {
	
	home.file."${instance_path}/mmc-pack".source = ./instances/fabric-client-1_21/mmc-pack.json;
        
	home.file."${config_path}/modernfix-mixins.properties".text = "mixin.perf.dynamic_resources=true";
	
	home.file."${config_path}/hm/replaymod.json" = {
	  text = builtins.toJSON {
	    recording = { 
	      indicator = false; 
	    };
	  };
	  onChange = '' 
	    rm -f ${config_path}/replaymod.json 
	    cp ${config_path}/hm/replaymod.json ${config_path}/replaymod.json
	    chmod u+w ${config_path}/replaymod.json
	  '';
	};

	home.file."${config_path}/hm/ryoamiclights.toml" = { 
	  text = ''
	    [light_sources]
	      tnt = "fancy"
	      creeper = "fancy"
	  '';
	  onChange = '' 
	    rm -f ${config_path}/ryoamiclights.toml
	    cp ${config_path}/hm/ryoamiclights.toml ${config_path}/ryoamiclights.toml
	    chmod u+w ${config_path}/ryoamiclights.toml
	  '';
	};

	home.file."${config_path}/hm/astrocraft.json" = {
	  text = builtins.toJSON {
	    showConstellations = true;
	  };
	  onChange = '' 
	    rm -f ${config_path}/astrocraft.json
	    cp ${config_path}/hm/astrocraft.json ${config_path}/astrocraft.json
	    chmod u+w ${config_path}/astrocraft.json
	  '';
	};

    })

  ]);

}
