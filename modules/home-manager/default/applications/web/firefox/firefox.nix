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
    };

  config = lib.mkIf cfg.enable {   

#    xdg.enable = true;
#    xdg.cacheHome."mozilla".force = true;
#    xdg.userDirs.".mozilla".force = true;

    programs.firefox = {
      enable = true;
      package = pkgs.firefox;

      arkenfox = { enable = true; version = "122.0"; };

      policies = {
	FirefoxHome = { Search = true; Pocket = false; Snippets = false; TopSites = false; Highlights = false; };
	SearchEngines = { Remove = [ "Google" "Wikipedia (en)" "Bing" ]; };
	NoDefaultBookmarks = false;
	DisablePocket = true;
	DisableFirefoxStudies = true;
        "3rdparty".Extensions = {
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

      profiles.Default = {
       
        extensions = with config.nur.repos.rycee.firefox-addons; [
#          bypass-paywalls-clean
	  ublock-origin
	  fastforwardteam
#	  istilldontcareaboutcookies
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
	  # Disables UI hiding on fullscreen
	  user_pref("browser.fullscreen.autohide", false);
	  # Enables userChrome, used for pretty rfp letterbox
	  user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          # Disables clipboard API, for websites that block copying / pasting
	  user_pref("dom.event.clipboardevents.enabled", false);
	  # Enables a search box in large dropdown menus
	  user_pref("dom.forms.selectSearch", true);
	  # Enables GPU sandboxing (enabled by default on windows)
	  user_pref("security.sandbox.gpu.level", true);
	  # Enables fission website isolation layer
	  user_pref("fission.autostart", true);
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
	'';

        # Prevents some random anoying white flash, as the comment says
	userContent = ''
          /* prevent white_flash on opening new tab/window */
          @-moz-document url("about:home"),url("about:blank"),url("about:newtab"),url("about:privatebrowsing") {
          body{ background-color: rgb(0,0,0) } }
	'';

        bookmarks = [
	  { 
	    name = "toolbar";
	    toolbar = true;
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
		toolbar = true;
		bookmarks = [
                  { name = "ayats"; url = "https://ayats.org/"; }
		];
	      }
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
	  "0300" = { enable = true; };
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

