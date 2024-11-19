# Here lies my bookmarks collection of vtubers i like >:D

{ config, lib, cfg, ... }: 

  let
    cfg = config.homeModules.default.applications.web.firefox;
  in {

    programs.firefox = {
      profiles.default.bookmarks = lib.mkIf (builtins.elem "vtubers" cfg.bookmarks) [
	{
	  name = "Vtubers :D";
	  bookmarks = [

	    {
	      name = "Streams";
	      bookmarks = [
		{ name = "Fallenshadow / shadow"; url = "https://twitch.tv/fallendhadow"; }
		{ name = "Filian"; url = "https://www.twitch.tv/filian"; }
		{ name = "Miyu"; url = "https://twitch.tv/miyuyus"; }
		{ name = "Denpafish"; url = "https://youtube.com/@denpafish"; }
		{ name = "Inis"; url = "https://twitch.tv/inislein"; }
		{ name = "Neuro-sama"; url = "https://twitch.tv/vedal987"; }
		{ name = "Saki"; url = "https://twitch.tv/saki_vtoob"; }
		{ name = "Anny"; url = "https://twitch.tv/anny"; }
		{ name = "Camila"; url = "https://twitch.tv/camila"; }
		{ name = "Miniko"; url = "https://twitch.tv/minikomew"; }
		{ name = "Bao"; url = "https://twitch.tv/bao"; }
		{ name = "Shylily"; url = "https://twitch.tv/shylily"; }
	      ];
	    }

	    {
	      name = "Relevant social media";
	      bookmarks = [
		{ name = "Fallenshadow / shadow | Twitter"; url = "https://twitter.com/fallenshadow_YT"; }
		{ name = "Fallenshadow / shadow | Twitter alt"; url = "https://twitter.com/goodgirlshadow"; }
		{ name = "Filian | Twitter"; url = "https://twitter.com/filianIsLost"; }
		{ name = "Miyu | Twitter"; url = "https://twitter.com/miyuyus_"; }
		{ name = "Miyu | Twitter alt"; url = "https://twitter.com/altmiyu"; }
		{ name = "Denpafish | Twitter"; url = "https://twitter.com/denpafish"; }
		{ name = "Inis | Twitter"; url = "https://twitter.com/Inislein"; }
		{ name = "Neuro-sama | Twitter"; url = "https://twitter.com/NeurosamaAI"; }
		{ name = "Saki | Twitter"; url = "https://twitter.com/Saki_vtoob"; }
		{ name = "Anny | Twitter"; url = "https://twitter.com/annytf"; }
		{ name = "Anny | Twitter alt"; url = "https://twitter.com/annylaifu"; }
		{ name = "Camila | Twitter"; url = "https://twitter.com/cumilq"; }
		{ name = "Camila | Twitter alt"; url = "https://twitter.com/sillycircusbaby"; }
		{ name = "Miniko | Twitter"; url = "https://twitter.com/minikomew"; }
		{ name = "Bao | Twitter"; url = "https://twitter.com/baovtuber"; }
		{ name = "Shylily | Twitter"; url = "https://twitter.com/shylilytwitch"; }
	      ];
	    }

	  ];
	}
      ];
    };
  
  }

