{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.social.discord;
  in lib.mkIf ( cfg.mods.enable && cfg.mods.client == "equibop" ) {

    xdg.configFile."equibop/HomeManagerInit_settings.json" = {
      text = builtins.toJSON {
         discordBranch = cfg.branch;
         minimizeToTray = "off";
      };
      onChange = ''  
        # Equibop doesn't play very nice with settings.json read-only. So we make it rw with some tricks
	# (this is a hacky way to copy the hm generated file instead of symlinking it)
        rm -f ${config.xdg.configHome}/equibop/settings.json
        cp ${config.xdg.configHome}/equibop/HomeManagerInit_settings.json ${config.xdg.configHome}/equibop/settings.json
        chmod u+w ${config.xdg.configHome}/equibop/settings.json
      '';
    };

    xdg.configFile."equibop/HomeManagerInit_state.json" = {
      text = builtins.toJSON {
	firstLaunch = false; 
      };
      onChange = ''  
        # Equibop doesn't play very nice with settings.json read-only. So we make it rw with some tricks
	# (this is a hacky way to copy the hm generated file instead of symlinking it)
        rm -f ${config.xdg.configHome}/equibop/state.json
        cp ${config.xdg.configHome}/equibop/HomeManagerInit_state.json ${config.xdg.configHome}/equibop/state.json
        chmod u+w ${config.xdg.configHome}/equibop/state.json
      '';
    };


    xdg.configFile."equibop/settings/HomeManagerInit_settings.json" = {
      text = builtins.toJSON {
	enableReactDevtools = true;
	plugins = {

	  # VENCORD / EQUICORD PLUGINS

	  BadgeAPI.enabled = true;
	  WhoReacted.enabled = true;
	  WebKeybinds.enabled = true;
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
	  MessageLogger.enabled = true;
	  AlwaysExpandRoles.enabled = true;
	  ConsoleJanitor.enabled = true;
	  Dearrow.enabled = true;
	  DontRoundMyTimestamps.enabled = true;
	  FixImagesQuality.enabled = true;
	  ILoveSpam.enabled = true;
	  MentionAvatars.enabled = true;
	  NoScreensharePreview.enabled = true;
	  PauseInvitesForever.enabled = true;
	  ReplaceGoogleSearch = {
	    enabled = true;
	    customEngineName = "DuckDuckGo";
	    customEngineURL = "https://duckduckgo.com/?q=";
	  };
	  RevealAllSpoilers.enabled = true;
	  SendTimestamps.enabled = true;
	  ShowHiddenThings.enabled = true;
	  StickerPaste.enabled = true;
	  ThemeAttributes.enabled = true;
	  VolumeBooster.enabled = true;
	  YoutubeAdblock.enabled = true;

	  # EQUICORD-ONLY PLUGINS

	  MessageLoggerEnhanced = { 
	    enabled = true; 
	    saveImages = true;
	    ignoreSelf = true;
	    hideMessagesFromMessageLoggers = true;
	    hideMessageFromMessageLoggersDeletedMessage = "no logs here";
	  };
	  AllCallTimers = {
	    enabled = true;
	    watchLargeGuides = true;
	  };
	  SoundBoardLogger.enabled = true;
	  AmITyping.enabled = true;
	  Anammox.enabled = true;
	  AtSomeone.enabled = true;
	  BannersEverywhere.enabled = true;
	  BetterActivities.enabled = true;
	  BetterAudioPlayer.enabled = true;
	  BetterInvites.enabled = true;
	  BetterUserArea.enabled = true;
	  CharacterCounter.enabled = true;
	  ClientSideBlock.enabled = true;
	  CopyFileContents.enabled = true;
	  CopyUserMention.enabled = true;
	  CuteNekos.enabled = true;
	  CutePats.enabled = true;
	  DeadMembers.enabled = true;
	  DecodeBase64.enabled = true;
	  DoNotLeak = {
	    enabled = true;
	    hoverToView = true;
	    enableForStream = true;
	  };
	  DontFilterMe.enabled = true;
	  FakeProfileThemesAndEffects.enabled = true;
	  FindReply = {
	    enabled = true;
	    includePings = true;
	  };
	  FixFileExtensions.enabled = true;
	  GlobalBadges.enabled = true;
	  HomeTyping.enabled = true;
	  Identity.enabled = true;
	  IgnoreTerms.enabled = true;
	  ImagePreview.enabled = true;
	  InRole.enabled = true;
	  JumpToStart.enabled = true;
	  LimitMiddleClickPaste.enabled = true;
	  MediaDownloader = {
	    enabled = true;
	    defaultGifQuality = 5;
	  };
	  ModalFade.enabled = true;
	  NewPluginsManager.enabled = true;
	  NoDeleteSafety.enabled = true;
	  NoMirroredCamera.enabled = true;
	  NoModalAnimation.enabled = true;
	  NoNitroUpsell.enabled = true;
	  NotificationTitle.enabled = true;
	  PinIcon.enabled = true;
	  QuestCompleter.enabled = true;
	  Quoter.enabled = true;
	  SearchFix.enabled = true;
	  SekaiStickers.enabled = true;
	  ShowBadgesInChat.enabled = true;
	  StreamerModeOn.enabled = true; # Same as "StreamerModeOnStream" on vencord
	  Timezones = {
	    enabled = true;
	    "24h Time" = true;
	  };
	  TranslatePlus.enabled = true;
	  UnitConverter = {
	    enabled = true;
	    myUnits = "metric";
	  };
	  UnlimitedAccounts.enabled = true;
	  UnreadCountBadge = {
	    enabled = true;
	    replaceWhiteDot = true;
	  };
	  UserPFP.enabled = true;
	  VideoSpeed = {
	    enabled = true;
	    preservePitch = true;
	  };
	  ViewRawVariant.enabled = true;
	  VoiceChannelLog.enabled = true;
	  WhosWatching.enabled = true;
	  WigglyText.enabled = true;
	  YoutubeDescription.enabled = true;
	};

	useQuickCss = true;
	enabledThemes = 
	 if ( cfg.mods.themes != null ) 
	  then lib.lists.forEach cfg.mods.themes ( value: value + ".css" ) 
	  else [ "" ];
	};

     onChange = ''  
	# Equibop doesn't play very nice with settings.json read-only. So we make it rw with some tricks
	# (this is a hacky way to copy the hm generated file instead of symlinking it)
	rm -f ${config.xdg.configHome}/equibop/settings/settings.json
	cp ${config.xdg.configHome}/equibop/settings/HomeManagerInit_settings.json ${config.xdg.configHome}/equibop/settings/settings.json
	chmod u+w ${config.xdg.configHome}/equibop/settings/settings.json
	'';
      };

      home.packages = [
	pkgs.equibop
      ];

  }
