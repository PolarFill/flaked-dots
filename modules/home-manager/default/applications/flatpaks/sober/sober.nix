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

    };

  config = lib.mkIf cfg.enable {
    
    systemd.user.services.sober-install = {

      Unit = {
        Description = "install sober flatpak";
        After = [ "manage-user-flatpaks.service" ];
      };

      Install = {
        WantedBy = [ "manage-user-flatpaks.service" ];
      };

      Service = {
        Type = "oneshot";
	Environment = "PATH=/run/current-system/sw/bin";
	ExecStart = "${pkgs.bash}/bin/bash -c 'if ${pkgs.flatpak}/bin/flatpak info org.vinegarhq.Sober &> /dev/null; then :; else ${pkgs.flatpak}/bin/flatpak install --noninteractive --user https://sober.vinegarhq.org/sober.flatpakref; fi'";
      };

    };

    home.file.".var/app/org.vinegarhq.Sober/data/sober/exe/ClientSettings/hm_ClientAppSettings.json" = {
      text = builtins.toJSON {
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
      };
      onChange = '' 
	rm -f .var/app/org.vinegarhq.Sober/data/sober/exe/ClientSettings/ClientAppSettings.json
        cp .var/app/org.vinegarhq.Sober/data/sober/exe/ClientSettings/hm_ClientAppSettings.json .var/app/org.vinegarhq.Sober/data/sober/exe/ClientSettings/ClientAppSettings.json
        chmod u+w .var/app/org.vinegarhq.Sober/data/sober/exe/ClientSettings/ClientAppSettings.json 
      '';
    };

  }; 
}
