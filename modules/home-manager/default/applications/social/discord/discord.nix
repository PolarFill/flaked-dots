{ pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.social.discord;
   
    client = 
      if cfg.mods.enable == false ||
      cfg.mods.client == "official"
      then "discord"
      else cfg.mods.client;

    capitalize = str: let
      first_char = builtins.substring 0 1 str;
      other_chars = lib.removePrefix first_char str;
    in
      ( lib.toUpper first_char ) + other_chars;

    get_avaible_resolution = str:
      if str == "discord" || str == "legcord" then "256x256" else "512x512";

    get_stupid_fucking_nomenclature = str:
      if str == "dorion" || str == "legcord" then "apps" else "app";

  in {

    options.homeModules.default.applications.social.discord = {

      enable = lib.options.mkEnableOption {
	default = false;
	description = "Enables discord! (with or without modifications)";
      };

      branch = lib.options.mkOption {
	default = "stable";
	type = lib.types.enum [ "stable" "canary" "ptb" ];
	description = "Which discord branch to use";

      };

      mods = {
	enable = lib.options.mkEnableOption {
	  default = true;
	  description= ''Whether to use modifications (mod injections, themes,
	  custom clients...) or not.'';
	};

	client = lib.options.mkOption {
	  default = "vesktop";
	  type = lib.types.enum [ "vesktop" "equibop" "webcord" "official" "dorion" "legcord" ];
	  description = ''
	  Chooses the discord client to be used.
	  "official" in this case means the official discord client.

	  Note that some clients may not be compatible with the chosen mods.
	  For instance, "vesktop" only supports vencord, and "equibop" only supports equicord.
	  '';
	};

	themes = lib.options.mkOption {
	  default = null;
	  type = lib.types.nullOr (lib.types.listOf lib.types.str);
	  description = "Sets the themes to be symlinked and loaded into the client";
	};
	
	shelter = {
	  enable = lib.options.mkEnableOption {};
	  immutable = lib.options.mkOption {
	    default = true;
	    type = lib.types.bool;
	    description = "Makes plugins not declared via nix be disabled on startup";
	  };
	  plugins = lib.options.mkOption {
	    default = [];
	    type = lib.types.listOf lib.types.str;
	    description = "List of shelter plugins to be enabled.";
	  };
	};

	equicord = {
	  enable = lib.options.mkEnableOption {};
	  immutable = lib.options.mkOption {
	    default = true;
	    type = lib.types.bool;
	    description = "Makes plugins not declared via nix be disabled on startup";
	  };
	  plugins = lib.options.mkOption {
	    default = [];
	    type = lib.types.listOf lib.types.str;
	    description = "List of equicord plugins to be enabled.";
	  };
	};

	vencord = {
	  enable = lib.options.mkEnableOption {};
	  immutable = lib.options.mkOption {
	    default = true;
	    type = lib.types.bool;
	    description = "Makes plugins not declared via nix be disabled on startup";
	  };
	  plugins = lib.options.mkOption {
	    default = [];
	    type = lib.types.listOf lib.types.str;
	    description = "List of vencord plugins to be enabled.";
	  };
	};

	betterdiscord = {
	  enable = lib.options.mkEnableOption {};
	  immutable = lib.options.mkOption {
	    default = true;
	    type = lib.types.bool;
	    description = "Makes plugins not declared via nix be disabled on startup";
	  };
	  plugins = lib.options.mkOption {
	    default = [];
	    type = lib.types.listOf lib.types.str;
	    description = "List of equicord plugins to be enabled.";
	  };
	};
      };

      flags = {

	vulkan_features = lib.options.mkOption {
	  default = false;
	  type = lib.types.bool;
	  description = "Enables some vulkan-related features of chromium";
	};

	vaapi = lib.options.mkOption {
	  default = false;
	  type = lib.types.bool;
	  description = "Enables flags to enforce VAAPI usage";
	};

	bypass_gpu_blocklist = lib.options.mkOption {
	  default = true;
	  type = lib.types.bool;
	  description = "Bypasses chromium's gpu blocklist";
	};

	wayland_optimizations = lib.options.mkOption {
	  default = false;
	  type = lib.types.bool;
	  description = "Enables some flags that may provide a smoother experience under wayland";
	};

	extra_flags = lib.options.mkOption {
	  default = null;
	  type = lib.types.nullOr lib.types.str;
	  description = "Extra flags to run along with the client";
	};

      };

    };

    config = lib.mkIf cfg.enable {

      xdg.desktopEntries.${client} = {
	name = capitalize client;
	genericName = "Discord";
	icon = "${pkgs.${client}}/share/icons/hicolor/${get_avaible_resolution client}/${get_stupid_fucking_nomenclature client}/${client}.png";
	exec = "${client}" +
	       "${if cfg.flags.vulkan_features && !cfg.flags.wayland_optimizations then " --use-gl=angle --use-angle=vulkan " else " "}" +
	       "${if cfg.flags.wayland_optimizations && !cfg.flags.vulkan_features then "--use-gl=egl" else " "}" +
	       "${if cfg.flags.bypass_gpu_blocklist then "--ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy" else ""}" +
	       "${if cfg.flags.wayland_optimizations then "--ozone-platform-hint=auto" else ""}" +
	       "${if cfg.flags.vulkan_features || cfg.flags.wayland_optimizations || cfg.flags.vaapi then "--enable-features=" else ""}" +
	       "${if cfg.flags.vulkan_features then "Vulkan,VulkanFromANGLE,DefaultANGLEVulkan," else ""}" +
	       "${if cfg.flags.vaapi then "VaapiIgnoreDriverChecks,VaapiVideoEncoder,VaapiVideoDecoder,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo," else ""}" +
	       "${if cfg.flags.wayland_optimizations then "UseOzonePlatform,WaylandWindowDecorations" else ""}" +
	       "${if cfg.flags.vaapi then "--disable-features=UseChromeOSDirectVideoDecoder" else ""}" +
	       "${if cfg.flags.extra_flags != null then cfg.flags.extra_flags else ""}";
	categories = [ "X-Social" "Network" "InstantMessaging" "Chat" ];
	mimeType = [ "x-scheme-handler/discord" ];
	settings = {
	  Keywords = "discord;${client};electron;chat";
	};
      };


      home.file = lib.mkIf ( cfg.mods.themes != null ) {
	themes_folder = {
	  target = ".config/${client}/themes";
	  source = ./themes;
	};
      };

    };
}
