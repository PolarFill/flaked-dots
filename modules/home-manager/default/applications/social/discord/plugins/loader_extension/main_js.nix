{ config, lib, ... }: 

  let
    cfg = config.homeModules.default.applications.social.discord;
  in 
    lib.mkIf (
      cfg.mods.enable &&
      cfg.mods.client == "dorion" ||
      cfg.mods.enable &&
      cfg.mods.client == "legcord"
    ) {
      
      home.file."${config.xdg.configHome}/${cfg.mods.client}_hm/content.js" = {
	text = 
	  let
	    
	    gen_shelter_plugins = plugins:
	      let
		code = builtins.concatStringsSep "\n" (
		  builtins.genList (i: 
		  ''
		  shelter.plugins.addRemotePlugin( "hm_plugin_${toString ( i + 1 )}", "${ builtins.elemAt plugins i }" );
		  shelter.plugins.startPlugin( id = "hm_plugin_${toString ( i + 1 )}" );
		  '' ) ( builtins.length plugins )
		);
	      in
		code;

	    load_shelter_plugins = /* js */ ''
	      function waitForShelter(callback) {
		  if (typeof shelter !== 'undefined') {
		      callback();
		  } else {
		      setTimeout(function() {
			  waitForShelter(callback);
		      }, 1000);
		  }
	      }

	      waitForShelter(function() {
	      
	      ${ lib.strings.optionalString cfg.mods.shelter.immutable ''
	      const installedShelterPlugins = shelter.plugins.installedPlugins();
	      const loadedShelterPlugins = shelter.plugins.loadedPlugins();

	      for (let pluginId in installedShelterPlugins) {
		  if (loadedPlugins && loadedShelterPlugins.hasOwnProperty(pluginId)) {
		      shelter.plugins.stopPlugin(pluginId);
		  }
		  if (installedShelterPlugins && installedPlugins.hasOwnProperty(pluginId)) {
		      shelter.plugins.removePlugin(pluginId);
		  }
	      }
	      '' }

	      ${ gen_shelter_plugins cfg.mods.shelter.plugins }
	      });
	    '' /* js */ ;

	    gen_vencord_plugins = plugins:
	      let
		code = builtins.concatStringsSep "\n" (
		  builtins.genList ( i: '' 
		    Vencord.Api.Settings.SettingsStore.store.plain.plugins.${builtins.elemAt plugins i}.enabled = true;
		  '') ( builtins.length plugins )
		);
	      in
		code;
	

	    vencord_load_themes = ''
	      
	    '';
    
	    load_vencord_plugins = '' 

              waitForVencord(function() {
              ${lib.optionalString ( cfg.mods.vencord.immutable || cfg.mods.equicord.immutable ) ''
		const installedVencordPlugins = Vencord.Api.Settings.SettingsStore.store.plain.plugins;
	      
		for (let plugin in installedVencordPlugins) {
                  installedVencordPlugins[plugin].enabled = false;
		}
	       ''}
		Vencord.Api.Settings.SettingsStore.store.plain.plugins.NoTrack.enabled = true;
		Vencord.Api.Settings.SettingsStore.store.plain.plugins.Settings.enabled = true;
		Vencord.Api.Settings.SettingsStore.store.plain.plugins.SupportHelper.enabled = true;

	      ${ 
		if cfg.mods.vencord.enable
		then gen_vencord_plugins cfg.mods.vencord.plugins 
		else if cfg.mods.equicord.enable
		then gen_vencord_plugins cfg.mods.equicord.plugins
		else "" 
	      }
	     
	      ${vencord_load_themes};

	      });
	    '';

	  in 
	    ''
	    if (typeof browser === "undefined") {
	      var browser = chrome;
	    }

	    try {

	      console.log("Starting up plugin loader...");

	      ${ lib.strings.optionalString ( cfg.mods.custom_mod != null ) 
	      ''
	      console.log("Injecting custom mod...");

	      const script = document.createElement("script");
	      script.src = browser.runtime.getURL("dist/bundle.js");
	      // documentElement because we load before body/head are ready
	      document.documentElement.appendChild(script);

	      const style = document.createElement("link");
	      style.type = "text/css";
	      style.rel = "stylesheet";
	      style.href = browser.runtime.getURL("dist/bundle.css");

	      document.documentElement.append(script);

	      document.addEventListener(
		"DOMContentLoaded",
		() => {
		  console.log("Appending stylesheets...")
		  document.documentElement.append(style);
		  document.documentElement.append(extraStyle);
		},
		{ once: true }
	      );
	      '' }

	      ${ lib.strings.optionalString ( cfg.mods.vencord.enable || cfg.mods.equicord.enable ) 
	      ''
	      console.log("Enabling vencord / equicord plugins...");

	      function waitForVencord(callback) {
		if (typeof Vencord !== 'undefined') {
		  callback();
		} else {
		  setTimeout(function() {
		    waitForVencord(callback);
		  }, 100);
		};
	      }

	      waitForVencord(function() {
		


		Vencord.Api.Settings.SettingsStore.store.plain.enabledThemes = JSON.parse(${builtins.toJSON cfg.mods.themes});

	      });

	      ''}

	      ${ lib.strings.optionalString cfg.mods.shelter.enable load_shelter_plugins }
	      ${ lib.strings.optionalString (cfg.mods.vencord.enable || cfg.mods.equicord.enable) load_vencord_plugins }

	    } catch(e){console.error(e)}
	    '';
	    
      };

  }
