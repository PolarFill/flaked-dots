{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.social.discord;
  in lib.mkIf ( cfg.mods.enable && cfg.mods.client == "vesktop" ) {

    xdg.configFile."vesktop/HomeManagerInit_settings.json" = {
      text = builtins.toJSON {
         discordBranch = "stable";
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

    xdg.configFile."vesktop/HomeManagerInit_state.json" = {
      text = builtins.toJSON {
	firstLaunch = false;
      };
      onChange = ''  
        # Vesktop doesn't play very nice with settings.json read-only. So we make it rw with some tricks
	# (this is a hacky way to copy the hm generated file instead of symlinking it)
        rm -f ${config.xdg.configHome}/vesktop/state.json
        cp ${config.xdg.configHome}/vesktop/HomeManagerInit_state.json ${config.xdg.configHome}/vesktop/state.json
        chmod u+w ${config.xdg.configHome}/vesktop/state.json
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
	  PreviewMessage.enabled = true;
	  PictureInPicture.enabled = true;
	  PermissionsViewer.enabled = true;
	  PermissionFreeWill.enabled = true;
	  OnePingPerDM.enabled = true;
	  oneko.enabled = true;
	  NoUnblockToJump.enabled = true;
	  NotificationVolume.enabled = true;
	  NormalizeMessageLinks.enabled = true;
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
	  AlwaysTrust.enabled = true;
	  AlwaysAnimate.enabled = true;
	  MoreUserTags.enabled = true;
	  MutualGroupDMs.enabled = true;
	  MoreKaomoji.enabled = true;
	  MessageLinkEmbeds.enabled = true;
	  NoPendingCount.enabled = true;
	  NSFWGateBypass.enabled = true;
	  QuickReply.enabled = true;
	  ReplyTimestamp.enabled = true;
	  ReserveImageSearch.enabled = true;
	  RelationshipNotifier.enabled = true;
	  ShikiCodeblocks = {
	    enabled = true;
	    useDevIcon = "Colored";
	  };
	  StreamerModeOnStream.enabled = true;
	  VoiceDownload.enabled = true;
	  BetterRoleDot.enabled = true;
	  BetterSettings.enabled = true;
	  BetterSessions.enabled = true;
	  BetterRoleContext.enabled = true;
	  F8Break.enabled = true;
	  FixSpotifyEmbeds.enabled = true;
	  GreetStickerPicker.enabled = true;
	  ImageLink.enabled = true;
	  ImplicitRelationships.enabled = true;
	  MessageLatency = {
	    enabled = true;
	    showMillis = true;
	  };
	  BetterFolders.enabled = true;
	  AutomodContext.enabled = true;
	  BetterNotesBox = { enabled = true; hide = true; };
	  Decor.enabled = true;
	  NoOnboardingDelay.enabled = true;
	  OpenInApp.enabled = true;
	  ReverseImageSearch.enabled = true;
	  ShowAllMessageButtons.enabled = true;
	  ShowTimeoutDuration.enabled = true;
	  SortFriendRequests.enabled = true;
	  Summaries.enabled = true;
	  SuperReactionTweaks.enabled = true;
	  Translate.enabled = true;
	  TimeBarAllActivities.enabled = true;
	  ValidReply.enabled = true;
	  WatchTogetherAdblock.enabled = true;
	  AlwaysExpandRoles.enabled = true;
	  ConsoleJanitor.enabled = true;
	  CopyFileContents.enabled = true;
	  Dearrow.enabled = true;
	  DontRoundMyTimestamps.enabled = true;
	  FixImagesQuality.enabled = true;
	  ILoveSpam.enabled = true;
	  MentionAvatars.enabled = true;
	  NoScreensharePreview.enabled = true;
	  PauseInvitesForever.enabled = true;
	  ReplaceGoogleSearch = {
	    enabled = true;
	    customEngineSearch = "DuckDuckGo";
	    customEngineURL = "https://duckduckgo.com/?q=";
	  };
	  RevealAllSpoilers.enabled = true;
	  SendTimestamps.enabled = true;
	  ShowHiddenThings.enabled = true;
	  StickerPaste.enabled = true;
	  ThemeAttributes.enabled = true;
	  VolumeBooster.enabled = true;
	  YoutubeAdblock.enabled = true;
	};

	useQuickCss = true;
	enabledThemes = 
	  if ( cfg.mods.themes != null ) 
	  then lib.lists.forEach cfg.mods.themes ( value: value + ".css" ) 
	  else [ "" ];
	};
     onChange = ''  
	# Vesktop doesn't play very nice with settings.json read-only. So we make it rw with some tricks
	# (this is a hacky way to copy the hm generated file instead of symlinking it)
	rm -f ${config.xdg.configHome}/vesktop/settings/settings.json
	cp ${config.xdg.configHome}/vesktop/settings/HomeManagerInit_settings.json ${config.xdg.configHome}/vesktop/settings/settings.json
	chmod u+w ${config.xdg.configHome}/vesktop/settings/settings.json
	'';
      };

      home.packages = [
	pkgs.vesktop
      ];

  }
