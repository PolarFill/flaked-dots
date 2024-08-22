{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.flatpaks.sober;
  in {
    options.homeModules.default.applications.flatpaks.sober = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables sober roblox compat layer for linux!";
      };

      fflags = lib.options.mkOption {
        default = "default";
	type = lib.types.nullOr lib.types.str;
        description = "Enables one of the fflags presets (default, perf, null)";
      };
   

    };

  config = lib.mkIf cfg.enable {
    
    services.flatpak.packages = [
      ":${./sober.flatpakref}"
    ];

    home.file.".var/app/org.vinegarhq.Sober/data/sober/exe/ClientSettings/hm_ClientAppSettings.json" = lib.mkIf (cfg.fflags != null) {
      text = lib.mkMerge [ 
	( if cfg.fflags == "default" then builtins.toJSON {
	  DFFlagOrder66 = "True";

	  FStringTencentAuthPath = "null";
	  FFlagSoundsUsePhysicalVelocity = "True";
	  FFlagEnableCapturesHotkeyExperiment_v4 = "False";
	  FFlagDebugTextBoxServiceShowOverlay = "True";

	  FFlagLuaAppUseUIBloxColorPalettes1 = "True";
	  FFlagUIBloxUseNewThemeColorPalettes = "True";
	  FIntRobloxGuiBlurIntensity = "0";
	  FFlagDebugDisplayUnthemedInstances = "True";
	  FFlagFixReducedMotionStuckIGM2 = "True";
	  DFIntTimestepArbiterThresholdCFLThou = "300";

	  FFlagEnableReportAbuseMenuRoactABTest2 = "True";
	  FFlagEnableInGameMenuChromeABTest2 = "True";
	  FFlagEnableInGameMenuChromeABTest3 = "True";

	  FFlagTopBarUseNewBadge = "True";
	  FStringTopBarBadgeLearnMoreLink = "https://duckduckgo.com/";
	  FStringVoiceBetaBadgeLearnMoreLink = "https://duckduckgo.com/";

	  FFlagUserShowGuiHideToggles = "True";
	  GuiHidingApiSupport2 = "True";

	  FIntDebugForceMSAASamples = "8";
	  DFFlagTextureQualityOverrideEnabled = "True";
	  DFIntTextureQualityOverride = "3";
	  FFlagFastGPULightCulling3 = "True";
	  FFlagCommitToGraphicsQualityFix = "True";
	  FFlagFixGraphicsQuality = "True";
	  DFIntMaxFrameBufferSize = "4";
	  FFlagNewLightAttenuation = "False";

	  FFlagDebugCheckRenderThreading = "True";
	  FFlagRenderDebugCheckThreading2 = "True";

	  FFlagDebugGraphicsDisableDirect3D11 = "True";
	  FFlagDebugGraphicsPreferVulkan = "True";
      } else "")

      ( if cfg.fflags == "perf" then ''
          {
	    "DFFlagDebugPauseVoxelizer": true,
	    "DFFlagDebugRenderForceTechnologyVoxel": true,
	    "DFFlagDisableDPIScale": false,
	    "DFFlagTextureQualityOverrideEnabled": true,
	    "DFIntCSGLevelOfDetailSwitchingDistance": 0,
	    "DFIntCSGLevelOfDetailSwitchingDistanceL12": 0,
	    "DFIntCSGLevelOfDetailSwitchingDistanceL23": 0,
	    "DFIntCSGLevelOfDetailSwitchingDistanceL34": 0,
	    "DFIntDebugFRMQualityLevelOverride": 1,
	    "DFIntDebugRestrictGCDistance": "1",
	    "DFIntMaxFrameBufferSize": "4",
	    "DFIntTaskSchedulerTargetFps": 9999,
	    "DFIntTextureCompositorActiveJobs": 0,
	    "DFIntTextureQualityOverride": 0,
	    "DFFlagDebugRenderForceTechnologyVoxel": true,
	    "FFlagAdServiceEnabled": false,
	    "FFlagCloudsReflectOnWater": false,
	    "FFlagDebugCheckRenderThreading": "True",
	    "FFlagDebugDisableTelemetryEphemeralCounter": true,
	    "FFlagDebugDisableTelemetryEphemeralStat": true,
	    "FFlagDebugDisableTelemetryEventIngest": true,
	    "FFlagDebugDisableTelemetryPoint": true,
	    "FFlagDebugDisableTelemetryV2Counter": true,
	    "FFlagDebugDisableTelemetryV2Event": true,
	    "FFlagDebugDisableTelemetryV2Stat": true,
	    "FFlagDebugGraphicsDisableDirect3D11": "True",
	    "FFlagDebugGraphicsPreferVulkan": "True",
	    "FFlagDebugSkyGray": true,
	    "FFlagDisablePostFx": true,
	    "FFlagEnableAndroidVsync": false,
	    "FFlagFastGPULightCulling3": true,
	    "FFlagFutureIsBrightPhase3Vulkan": true,
	    "FFlagGameBasicSettingsFramerateCap5": true,
	    "FFlagGlobalWindActivated": "False",
	    "FFlagGlobalWindRendering": "False",
	    "FFlagRealMobileOutline": false,
	    "FFlagRenderCheckThreading": true,
	    "FFlagRenderDebugCheckThreading2": "True",
	    "FFlagUserHandleChatHotKeyWithContextActionService": true,
	    "FIntDebugForceMSAASamples": 0,
	    "FIntFRMMaxGrassDistance": 0,
	    "FIntFRMMinGrassDistance": 0,
	    "FIntRenderGrassDetailStrands": 0,
	    "FIntRenderGrassHeightScaler": 0,
	    "FIntRenderLocalLightFadeInMs": "0",
	    "FIntRenderLocalLightUpdatesMax": 1,
	    "FIntRenderLocalLightUpdatesMin": 1,
	    "FIntRenderShadowIntensity": 0,
	    "FIntTerrainArraySliceSize": "4",
	    "FFlagCoreGuiTypeSelfViewPresent": false,
	    "FFlagEnableInGameMenuChromeABTest2": "False",
	    "FFlagEnableReportAbuseMenuRoactABTest2": "False",
	    "FFlagEnableInGameMenuChromeABTest3": "False",
	    "FIntFullscreenTitleBarTriggerDelayMillis": "3600000",
	    "FFlagUserShowGuiHideToggles": "True",
	    "FIntDebugTextureManagerSkipMips": "8",
	    "FIntRenderShadowmapBias": "-1",
	    "DFIntAnimationLodFacsDistanceMin": "0",
	    "DFIntAnimationLodFacsDistanceMax": "0",
	    "DFIntAnimationLodFacsVisibilityDenominator": "0",
	    "FFlagFixGraphicsQuality": "True",
	    "DFIntCullFactorPixelThresholdShadowMapHighQuality": "2147483647",
	    "DFIntCullFactorPixelThresholdShadowMapLowQuality": "2147483647",
	    "FFlagDebugRenderingSetDeterministic": "True",
	    "FFlagTaskSchedulerLimitTargetFpsTo2402": "False",
	    "DFIntDefaultTimeoutTimeMs": "10000",
	    "FFlagRenderFixFog": "True",
	    "FIntRobloxGuiBlurIntensity": "0"
	  }
      '' else "" )
      
    ];
      onChange = '' 
	rm -f .var/app/org.vinegarhq.Sober/data/sober/exe/ClientSettings/ClientAppSettings.json
        cp .var/app/org.vinegarhq.Sober/data/sober/exe/ClientSettings/hm_ClientAppSettings.json .var/app/org.vinegarhq.Sober/data/sober/exe/ClientSettings/ClientAppSettings.json
        chmod u+w .var/app/org.vinegarhq.Sober/data/sober/exe/ClientSettings/ClientAppSettings.json 
      '';
    };

  }; 
}
