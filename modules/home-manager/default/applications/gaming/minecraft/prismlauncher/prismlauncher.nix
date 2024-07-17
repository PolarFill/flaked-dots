{  pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.gaming.minecraft.prismlauncher;
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

   # ( config.lib.mkIf ( builtins.elem "fabric-client-1.21" cfg.instances ) import ./instances/fabric-client-121 )

  ]);

}
