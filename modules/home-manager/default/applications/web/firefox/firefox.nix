# Worth reading: https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/26

{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.web.firefox;
  in {

    options.homeModules.default.applications.web.firefox = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables the firefox browser! (developer edition)";
      };

      bookmarks = lib.options.mkOption {
	default = [ "nixos" ];
	type = lib.types.listOf lib.types.str;
	description = "Enables the specified lists of bookmarks";
      };

      doh = {
	enable = lib.options.mkOption {
	  default = false;
	  description = "Enables dns over https";
	};	
	mode = lib.options.mkOption {
	  default = null;
	  type = lib.types.nullOr lib.types.str;
	  description = "Sets the doh_mode (see https://wiki.mozilla.org/Trusted_Recursive_Resolver). No effect if doh is disabled";
	};
      };

      proxies = {
	i2p = {
	  enable = lib.options.mkEnableOption { default = false; };
	  host = lib.options.mkOption { default = "127.0.0.1"; type = lib.types.str; };
	  port = lib.options.mkOption { default = "4444"; type = lib.types.str; };
	};
      };

    };

  config = lib.mkIf cfg.enable {   

    programs.firefox = {
      enable = true;
      package = pkgs.firefox-beta;

      arkenfox = { enable = true; version = "128.0"; };
      
      policies = {
	FirefoxHome = { Search = true; Pocket = false; Snippets = false; TopSites = false; Highlights = false; };
	SearchEngines = { Remove = [ "Google" "Wikipedia (en)" "Bing" ]; };
	NoDefaultBookmarks = false;
	DisablePocket = true;
	DisableFirefoxStudies = true;
        "3rdparty".Extensions = {
	/*
	  "foxyproxy@eric.h.jung" = {
	    "mode" = "pattern";
	    "sync" = false;
            "autoBackup" = false;
            "showPatternProxy" = false;
            "passthrough" = "";
            "container" = {
              "incognito" = "";
              "container-1" = "";
              "container-2" = "";
              "container-3" = "";
              "container-4" = "";
            };
            "commands" = {
              "setProxy" = "";
              "setTabProxy" = "";
              "quickAdd" = "";
            };
	    "data" = [ 
	      {
		"active" = cfg.proxies.i2p.enable;
		"title" = "I2P HTTP Proxy";
		"type" = "http";
		"hostname" = cfg.proxies.i2p.host;
		"port" = cfg.proxies.i2p.port;
		"color" = "#e01b24";
	      }
	    ];
	  };
	*/
          "uBlock0@raymondhill.net".adminSettings = {
            userSettings = rec { 
	      uiTheme = "dark"; 
	      cloudStorageEnabled = false;
	      importedLists = [ 
	        "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt" 
		"https://raw.githubusercontent.com/easylistbrasil/easylistbrasil/filtro/easylistbrasil.txt"
                "https://fanboy.co.nz/fanboy-espanol.txt"
		"https://easylist-downloads.adblockplus.org/easylistportuguese.txt"
		"https://raw.githubusercontent.com/deathbybandaid/piholeparser/master/Subscribable-Lists/CountryCodesLists/Brazil.txt"
		"https://raw.githubusercontent.com/kowith337/PersonalFilterListCollection/master/filterlist/imageboard/GelboLube.txt"
		"https://raw.githubusercontent.com/PoorPocketsMcNewHold/steamscamsites/master/steamscamsite.txt"
		"https://raw.githubusercontent.com/Hunter-Github/the-best-stack-overflow/master/se_filters.txt"
                "https://gothub.lunar.icu/mchangrh/yt-neuter/blob/main/docs/filters/sponsorblock.md"
		];
	      externalLists = lib.concatStringsSep "\n" importedLists;
	    };
	    selectedFilterLists = [
	      "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt" 
	      "https://gothub.lunar.icu/mchangrh/yt-neuter/blob/main/docs/filters/sponsorblock.md"
	      "https://raw.githubusercontent.com/easylistbrasil/easylistbrasil/filtro/easylistbrasil.txt"
              "https://fanboy.co.nz/fanboy-espanol.txt"
	      "https://easylist-downloads.adblockplus.org/easylistportuguese.txt"
	      "https://raw.githubusercontent.com/deathbybandaid/piholeparser/master/Subscribable-Lists/CountryCodesLists/Brazil.txt"
              "https://raw.githubusercontent.com/kowith337/PersonalFilterListCollection/master/filterlist/imageboard/GelboLube.txt"
	      "https://raw.githubusercontent.com/PoorPocketsMcNewHold/steamscamsites/master/steamscamsite.txt"
	      "https://raw.githubusercontent.com/Hunter-Github/the-best-stack-overflow/master/se_filters.txt"
	      "spa-1"  # For pt/spanish blocks; maybe you dont need this
	      "adguard-generic"
	      "adguard-annoyance"
	      "adguard-social"
	      "adguard-spyware"
	      "adguard-spyware-url"
	      "adguard-mobile-app-banners"
	      "adguard-other-annoyances"
	      "adguard-cookies"
	      "adguard-popup-overlays"
	      "block-lan"
	      "fanboy-cookiemonster"
	      "easylist"
              "easyprivacy"
	      "plowe-0"
	      "mvps-0"
	      "ublock-abuse"
	      "ublock-badware"
	      "ublock-filters"
	      "ublock-privacy"
	      "ublock-quick-fixes"
	      "ublock-unbreak"
	      "ublock-cookies-adguard"
	      "ublock-annoyances"
	      "ublock-experimental"
	      "urlhaus-1"
	      "dpollock-0"
	      "curben-phishing"
	    ];
	  };
	};
      };

      # Mostly arkenfox overrides
      # https://arkenfox.dwarfmaster.net/ and https://github.com/dwarfmaster/arkenfox-nixos
      # for how to config

      profiles.default = {
       
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
         # bypass-paywalls-clean
	  indie-wiki-buddy
	  ublock-origin
	  violentmonkey
	  darkreader
	  sponsorblock
	  web-scrobbler
	  libredirect
          export-tabs-urls-and-titles
	  terms-of-service-didnt-read
	];

	search.default = "DuckDuckGo";
	search.privateDefault = "DuckDuckGo";

	extraConfig = ''
	  # Make extensions auto-enable themselves at first start :D
	  user_pref("extensions.autoDisableScopes", 0);

          # Disables clipboard API, for websites that block copying / pasting
	  user_pref("dom.event.clipboardevents.enabled", false);

	  # Disables UI hiding on fullscreen
	  user_pref("browser.fullscreen.autohide", false);
	  # Enables userChrome, used for pretty rfp letterbox
	  user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
	  # Enables a search box in large dropdown menus
	  user_pref("dom.forms.selectSearch", true);

	  # Enables GPU sandboxing (enabled by default on windows)
	  user_pref("security.sandbox.gpu.level", true);
	  # Enables fission website isolation layer
	  user_pref("fission.autostart", true);
	  # Disable region updates
	  user_pref("browser.region.network.url", "");
	  user_pref("browser.region.update.enabled", false);
	  # Disable extra telemetry
	  user_pref("browser.search.serpEventTelemetry.enabled",false);
	  # Disable privacy-preserving attribution
	  user_pref("dom.private-attribution.submission.enabled", false);
	  # Disable relay email feature
	  user_pref("signon.firefoxRelay.feature", "disabled");

	  # Arkenfox v128 disables RFP in favor of FPP for crowd-hiding purposes
	  # I still prefer rfp though. Using it doesn't have any dowsides
	  # besides the usual website breakages :p
	  # Also disables webgl and spoofs english, as v128 also disables those by default
	  user_pref("privacy.resistFingerprinting", true);
	  user_pref("privacy.resistFingerprinting.letterboxing", true);
	  user_pref("webgl.disabled", true);
	  user_pref("privacy.spoof_english", 2);

	  # Enable DoH (enabling it from arkenfox doesnt work for some reason)
	  ${if cfg.doh.enable then "user_pref(\"network.trr.mode\", ${cfg.doh.mode});" else ""}
	  ${if cfg.doh.enable then "user_pref(\"network.trr.uri\", \"https://dns.quad9.net/dns-query\");" else ""}
	  ${if cfg.doh.enable then "user_pref(\"network.trr.custom_uri\", \"https://dns.quad9.net/dns-query\");" else ""}

	  # Enables http pipelining (sending multiple http requests instead of one)
	  user_pref("network.http.pipelining", true);
	  user_pref("network.http.proxy.pipelining", true);
	  user_pref("network.http.pipelining.maxrequests", 10);

	  # From what i could gather this kills webrtc (for connections outside proxies i assume)?
	  # Documentation about this is poor, but it is a requirement listed in the i2p website
	  # and it still hasnt affected me (though i should mention i dont use webrtc anyway :p)
	  user_pref("media.peerconnection.ice.proxy_only", true);
	  '';

        # Makes RFP letterbox dark (cause the default burns my eyes)
	# Imported rose-pine theme cause this file is already long as hell
	userChrome = ''
          @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

          /* letterbox color */
          #tabbrowser-tabpanels {
          background-color: rgb(0,0,0) !important; }
	
          /* prevent bookmarks to hide on fullscreen (yeah, weird) */
          #navigator-toolbox[inFullscreen] #PersonalToolbar{
          visibility: visible !important; }

	  /* Disable the "Import Bookmarks" button. */
	  #import-button { display: none; }
	'';

        # Prevents some random anoying white flash, as the comment says
	userContent = ''
          /* prevent white_flash on opening new tab/window */
          @-moz-document url("about:home"),url("about:blank"),url("about:newtab"),url("about:privatebrowsing") {
          body{ background-color: rgb(0,0,0) } }
	'';

        bookmarks = [
	  { 
	    name = "NixOS";
	    bookmarks = [
	      { name = "MyNixOS"; url = "https://mynixos.com"; }
	      { name = "NUR Search"; url = "https://nur.nix-community.org/"; }
	      { name = "Nixpkgs search"; url = "https://search.nixos.org/packages"; }
	      { name = "Home-manager search"; url = "https://home-manager-options.extranix.com/"; }
	      { name = "awesome-nix"; url = "https://github.com/nix-community/awesome-nix"; }
	      { name = "nix.dev"; url = "https://nix.dev/"; }
	      { name = "Nix official wiki"; url = "https://wiki.nixos.org/"; }
	      { name = "Chaotic-nyx package list"; url = "https://www.nyx.chaotic.cx/#lists-of-options-and-packages"; }
	      { name = "List of builtins and lib"; url = "https://teu5us.github.io/nix-lib.html"; }
	      { name = "Noogle.dev"; url = "https://noogle.dev"; }
	      { name = "FlakeHub"; url = "https://flakehub.com/flakes"; }
	      { name = "NixOS Discourse"; url = "https://discourse.nixos.org"; }
	      { name = "NixOS Types list"; url = "https://nlewo.github.io/nixos-manual-sphinx/development/option-types.xml.html"; }
	      { name = "NixPkgs Track"; bookmarks = [
		{ name = "NixPkgs issue tracker"; url = "https://nixpk.gs/"; }
		{ name = "NixPkgs repo"; url = "https://github.com/NixOS/nixpkgs"; }
		{ name = "NixPkgs update track"; url = "https://status.nixos.org"; }
	      ];}
	      { name = "Nix contributions"; bookmarks = [
		{ name = "How to contribute"; url = "https://nix.dev/contributing/how-to-contribute.html"; }
		{ name = "Nixpkgs contribution guide"; url = "https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md"; }
		{ name = "Latest nixos-unstable release"; url = "https://channels.nixos.org/nixpkgs-unstable/git-revision"; }
		{ name = "Nixpkgs manual"; url = "https://nixos.org/manual/nixpkgs/stable/"; }
	      ];}
	    ];
	  }
	  {
            name = "Blogs";
	    bookmarks = [
	      { name = "ayats"; url = "https://ayats.org/"; }
	      { name = "fasterthanlii.me"; url = "https://fasterthanli.me/"; }
	    ];
	  }
	  {
	    name = "Social";
	    bookmarks = [
	      { name = "voidus misskey"; url = "https://social.voidus.dev/"; }
	    ];
	  }
	];

	arkenfox = {
	  enable = true;
          "0000".enable = true;
	  "0100" = { 
	    enable = true; 
	    "0102"."browser.startup.page".value = 3; 
            "0103"."browser.startup.homepage".value = "about:home";
	    "0104"."browser.newtabpage.enabled".value = true;
	  };
	  "0200" = { enable = true; };
	  "0300" = { 
	    enable = true; 
	    # Crash report enabled cause it helps me debug stuff
	    "0350"."breakpad.reportURL".value = "https://crash-stats.mozilla.org/report/index/"; 
	  };
	  "0400" = { enable = true; };
	  "0600" = { enable = true; };
	  "0700" = { enable = true; };
	  "0800" = { enable = true; "0820"."layout.css.visited_links_enabled".value = true; };
	  "0900" = { enable = true; };
	  "1000" = { 
	    enable = true; 
	    "1006"."browser.shell.shortcutFavicons".value = true; 
	    "1001"."browser.cache.disk.enable".value = true; 
	  };
	  "1200" = { enable = true; };
          "1600" = { enable = true; };
	  "1700" = { enable = true; };
	  "2000" = { enable = true; };
	  "2400" = { enable = true; };
	  "2600" = { 
	    enable = true; 
	    "2660"."extensions.enabledScopes".value = 0; 
	    "2660"."extensions.autoDisableScopes".value = 15;
	    "2651"."browser.download.useDownloadDir".value = true;
	  };
	  "2700" = { enable = true; };
	  "2800" = { enable = true; "2811"."privacy.clearOnShutdown.history".value = false; };
	  "4500" = { enable = true; };
	  "5000" = { 
	    enable = true;
	    "5001"."browser.privatebrowsing.autostart".value = false;
	    "5002"."browser.cache.memory.enable".value = true;
	    "5002"."browser.cache.memory.capacity".value = -1;
	    "5004"."permissions.memory_only".value = false;
	    "5005"."security.nocertdb".value = false;
	    "5006"."browser.chrome.site_icons".value = true;
	    "5008"."browser.sessionstore.resume_from_crash".value = true;
	    "5013"."places.history.enabled".value = true;
	    "5016"."browser.download.folderList".value = 1;
	  };
	  "6000" = { enable = true; };
	  "9000" = { enable = true; };
	};
      };
    };
  };
}

