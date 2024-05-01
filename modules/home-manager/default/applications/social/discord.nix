{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.social.discord;
  in {
    options.homeModules.default.applications.social.discord = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables discord canary (vesktop + openASAR)!";
      };
    };

  config = lib.mkIf cfg.enable {   
    home.packages = with pkgs; [
      (vesktop.override {
        withSystemVencord = false;
       })
    ];

    xdg.desktopEntries.vesktop = {
      name = "Vesktop";
      genericName = "Discord";
      exec = "vesktop --use-gl=angle --use-angle=vulkan --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo,UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto";
      terminal = false;
      categories = [ "X-Social" ];
    };

    xdg.configFile."vesktop/HomeManagerInit_settings.json" = {
      text = builtins.toJSON {
         discordBranch = "canary";
         minimizeToTray = "off";
       };
      onChange = ''  
        # Vesktop doesn't play very nice with settings.json read-only. So we make it rw with some tricks
	# (this is a hacky way to copy the hm generated file instead of symlinking it)
        rm -f ${config.xdg.configHome}/vesktop/settings.json
        cp ${config.xdg.configHome}/vesktop/HomeManagerInit_settings.json ${config.xdg.configHome}/vesktop/settings.json
        chmod u+w ${config.xdg.configHome}/vesktop/settings.json
      '';
    };

    xdg.configFile."vesktop/settings/HomeManagerInit_settings.json" = {
    text = builtins.toJSON {
      enableReactDevtools = true;
      plugins = {
        BadgeAPI.enabled = true;
	WhoReacted.enabled = true;
	WebKeybinds.enabled = true;
	ViewRaw.enabled = true;
	VoiceChatDoubleClick.enabled = true;
	ViewIcons.enabled = true;
	VencordToolbox.enabled = true;
	ValidUser.enabled = true;
	USRBG.enabled = true;
	UserVoiceShow.enabled = true;
	UnsuppressEmbeds.enabled = true;
	UnlockedAvatarZoom.enabled = true;
	TypingTweaks.enabled = true;
	TypingIndicator.enabled = true;
	StartupTimings.enabled = true;
	SilentMessageToggle.enabled = true;
	ShowMeYourName.enabled = true;
	ShowTimeouts.enabled = true;
	ShowHiddenChannels.enabled = true;
	ShowConnections.enabled = true;
	ServerProfile.enabled = true;
	ServerListIndicators.enabled = true;
	SearchReply.enabled = true;
	RoleColorEverywhere.enabled = true;
	ReviewDB.enabled = true;
	ResurrectHome.enabled = true;
	ReadAllNotificationsButton.enabled = true;
	ReactErrorDecoder.enabled = true;
	PronounDB.enabled = true;
	PlatformIndicators.enabled = true;
	PlainFolderIcon.enabled = true;
	PreviewMessage.enabled = true;
	PictureInPicture.enabled = true;
	PermissionsViewer.enabled = true;
	PermissionFreeWill.enabled = true;
	OnePingPerDM.enabled = true;
	oneko.enabled = true;
	NoUnblockToJump.enabled = true;
	NotificationVolume.enabled = true;
	NormalizeMessageLinks.enabled = true;
	NoProfileThemes.enabled = true;
	NoMosaic.enabled = true;
	NoDevtoolsWarning.enabled = true;
	NewGuildSettings.enabled = true;
	MessageLogger.enabled = true;
	LoadingQuotes.enabled = true;
	MemberCount.enabled = true;
	KeepCurrentChannel.enabled = true;
	iLoveSpam.enabled = true;
	ImageZoom.enabled = true;
	GifPaste.enabled = true;
	FriendsSince.enabled = true;
	FixYoutubeEmbeds.enabled = true;
	ForceOwnerCrown.enabled = true;
	FixCodeblockGap.enabled = true;
	FakeNitro.enabled = true;
	FakeProfileThemes.enabled = true;
	Experiments.enabled = true;
	DisableCallIdle.enabled = true;
	EmoteCloner.enabled = true;
	CrashHandler.enabled = true;
	CopyUserURLs.enabled = true;
	ColorSighted.enabled = true;
	ClearURLs.enabled = true;
	CallTimer.enabled = true;
	BlurNSFW.enabled = true;
	BiggerStreamPreview.enabled = true;
	BetterUploadButton.enabled = true;
	BetterGifAltText.enabled = true;
	AnonymiseFileNames.enabled = true;
	BANger.enabled = true;
	AlwaysTrust.enabled = true;
	AlwaysAnimate.enabled = true;
        };
      };
   onChange = ''  
      # Vesktop doesn't play very nice with settings.json read-only. So we make it rw with some tricks
      # (this is a hacky way to copy the hm generated file instead of symlinking it)
      rm -f ${config.xdg.configHome}/vesktop/settings/settings.json
      cp ${config.xdg.configHome}/vesktop/settings/HomeManagerInit_settings.json ${config.xdg.configHome}/vesktop/settings/settings.json
      chmod u+w ${config.xdg.configHome}/vesktop/settings/settings.json
      '';
    };
  };
}
